// id, Title, PublishDate, GithubCode, link, LastModified, Price
import { createSlice } from '@reduxjs/toolkit'

export const userSlice = createSlice({
    name: 'user',
    initialState: {
        id: '',
        name: 'user',
        role: 'user',
        vipTier: 0,
        cartId: '',
        isLogin: false,
    },
    reducers: {
        login: (state, actions) => {
            state.id = actions.payload.id;
            state.name = actions.payload.username;
            state.role = actions.payload.role;
            state.isLogin = true;
            state.vipTier = actions.payload.VipTier;
            state.cartId = actions.payload.CartID;
        },
        logout: (state, actions) => {
            state.isLogin = false;
            state.id = '';
            state.name = '';
            state.role = '';
            state.cartId = '';
            state.vipTier = 0;
            state.cartId = '';
            localStorage.removeItem('email');
            localStorage.removeItem('password');
        }

    },
})

// Action creators are generated for each case reducer function
export const { login, logout } = userSlice.actions

export default userSlice.reducer