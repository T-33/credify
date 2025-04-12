import Router from 'koa-router';
import {
    getAllUsers,
    deleteUserById,
} from '../services/index.js';

export const usersRouter = new Router();

usersRouter.get('/users', async (ctx) => {
    const allUsers = await getAllUsers();

    ctx.body = {
        users: allUsers,
    };
    ctx.status = 200;
});

usersRouter.delete('/users/:id', async (ctx) => {
    if (!ctx.state.user) {
        throw new Error('Unauthorized');
    }

    //tokens associated with user are also deleted, making current cookie useless;
    await deleteUserById(ctx.params.id);

    ctx.status = 200;
    ctx.body = { };
});
