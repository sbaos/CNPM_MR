import { configureStore } from '@reduxjs/toolkit'
import saSlice from './saSlice'
import userSlice from './userSlice'
export default configureStore({
    reducer: {
        sa: saSlice,
        user: userSlice
    },
})