import Router from 'koa-router';
import Joi from 'joi';

import { getLoanSupportResponse } from '../services/openai.js';

export const supportRouter = new Router();

supportRouter.post('/get-ai-answer', async (ctx) => {
    console.log('post request to /get-ai-answer', ctx.request.body);

    const joiSchema = Joi.object({
        userMessage: Joi.string().required(),
    });

    const { userMessage } = await joiSchema.validateAsync(ctx.request.body);

    const aiAnswer = await getLoanSupportResponse(userMessage);

    ctx.body = {
        success: true,
        response: aiAnswer,
    };
    ctx.status = 200;
});
