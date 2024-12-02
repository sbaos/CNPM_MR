import { createSlice } from '@reduxjs/toolkit'

export const saSlice = createSlice({
    name: 'sa',
    initialState: {
        list: []
    },
    reducers: {
        addSA: (state, actions) => {
            state.list.append(actions.payload);
        },
        initSA: (state, actions) => {
            state.list = actions.payload;
        },
        changeSA_ID: (state, actions) => {
            const { id } = actions.payload;
            state.list = state.list.map((item) => {
                if (item.id === id) {
                    return { ...item, ...actions.payload };
                }
                return item;
            });
        },
        removeSA: (state, actions) => {
            state.list = state.list.filter((item) => {
                if (item.id === actions.payload) {
                    return false;
                }
                return true;
            });
        }
    },
})

// Action creators are generated for each case reducer function
export const { addSA, initSA, changeSA_ID, removeSA } = saSlice.actions

export default saSlice.reducer