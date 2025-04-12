import * as crypto from 'node:crypto';
import Router from 'koa-router';
import Joi from 'joi';
import bcrypt from 'bcrypt';
import {
    createToken,
    deleteToken,
    createUser,
    getUserByPin,
} from '../services/index.js';

export const authRouter = new Router();

authRouter.post('/register', async (ctx) => {
    console.log('post request to /user', ctx.request.body);

    const joiSchema = Joi.object({
        name: Joi.string().alphanum().required(),
        pin: Joi.number().integer().min(10000000000000).max(99999999999999),
        phone: Joi.string().pattern(/^\+[1-9]\d{1,14}$/).required()
            .messages({
                'string.pattern.base': 'Phone number must be in E.164 format (e.g., +1234567890)'
            })
    });

    const { name, pin, phone } = await joiSchema.validateAsync(ctx.request.body);

    await createUser({
        name,
        pin,
        phone
    });

    ctx.body = {
        success: true,
        newUser: { name},
    };
    ctx.status = 201;
});

authRouter.post('/login', async (ctx) => {
    console.log('post request to /login');

    const joiSchema = Joi.object({
        name: Joi.string().alphanum().required(),
        pin: Joi.number().integer().min(10000000000000).max(99999999999999),
        phone: Joi.string().pattern(/^\+[1-9]\d{1,14}$/).required()
            .messages({
                'string.pattern.base': 'Phone number must be in E.164 format (e.g., +1234567890)'
            })
    });

    const { pin } = await joiSchema.validateAsync(ctx.request.body);

    const dbUser = await getUserByPin(pin);

    if (!dbUser) {
        ctx.status = 401;
        throw new Error('USER NOT FOUND');
    }

    const token = crypto.randomBytes(20).toString('hex');

    await createToken({
        token,
        user_id: dbUser.user_id,
    });

    ctx.cookies.set('token', token, { httpOnly: true });

    ctx.status = 200;
    ctx.body = {
        message: 'Login successful',
        user: dbUser,
        token,
    };
});

authRouter.post('/logout', async (ctx) => {
    const token = ctx.cookies.get('token');

    if (!token) {
        throw new Error('Not authorized');
    }

    console.log({ token });

    ctx.state.user = null;

    await deleteToken(token);

    ctx.cookies.set('token', null);
    ctx.state.user = null;
});
