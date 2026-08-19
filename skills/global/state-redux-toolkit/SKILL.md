---
name: state-redux-toolkit
description: Production conventions for Redux Toolkit (RTK) state management, typed hooks, slices, and RTK Query with tag-based cache invalidation in TypeScript React applications. Use when configuring global client state, creating slices, writing async thunks, or building RTK Query API layers.
---

# Redux Toolkit (RTK) & RTK Query Architecture Guide

## When to use this skill
Trigger whenever configuring global state, creating Redux Toolkit slices, implementing typed async thunks, configuring RTK Query API endpoints, or testing Redux state in React TypeScript apps.

---

## 1. Core Principles

- **Local vs Global**: Keep local UI state in `useState` and form states in local components. Use Redux strictly for global app state (auth sessions, global settings, cross-screen workflows).
- **Server Cache in RTK Query**: Use RTK Query instead of hand-rolled thunks for fetching, caching, and synchronizing server data.
- **Strict Typing**: Never use `any` in slice state interfaces. Always use typed `useAppDispatch` and `useAppSelector` hooks.

---

## 2. Production Code Patterns

### A. Typed Store Setup & Custom Hooks
```ts
// src/store/index.ts
import { configureStore } from '@reduxjs/toolkit';
import { useDispatch, useSelector, type TypedUseSelectorHook } from 'react-redux';
import authReducer from './slices/authSlice';
import { apiSlice } from './api/apiSlice';

export const store = configureStore({
  reducer: {
    auth: authReducer,
    [apiSlice.reducerPath]: apiSlice.reducer,
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware().concat(apiSlice.middleware),
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

export const useAppDispatch: () => AppDispatch = useDispatch;
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector;
```

### B. Typed Slice with State & Reducers
```ts
// src/store/slices/authSlice.ts
import { createSlice, type PayloadAction } from '@reduxjs/toolkit';

export interface UserSession {
  id: string;
  email: string;
  role: 'admin' | 'user';
}

interface AuthState {
  user: UserSession | null;
  isAuthenticated: boolean;
  token: string | null;
}

const initialState: AuthState = {
  user: null,
  isAuthenticated: false,
  token: null,
};

export const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    setCredentials: (
      state,
      action: PayloadAction<{ user: UserSession; token: string }>
    ) => {
      state.user = action.payload.user;
      state.token = action.payload.token;
      state.isAuthenticated = true;
    },
    logout: (state) => {
      state.user = null;
      state.token = null;
      state.isAuthenticated = false;
    },
  },
});

export const { setCredentials, logout } = authSlice.actions;
export default authSlice.reducer;
```

### C. RTK Query with Tag-Based Cache Invalidation
```ts
// src/store/api/apiSlice.ts
import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react';

export const apiSlice = createApi({
  reducerPath: 'api',
  baseQuery: fetchBaseQuery({ baseUrl: '/api/v1' }),
  tagTypes: ['Projects', 'Tasks'],
  endpoints: (builder) => ({
    getProjects: builder.query<Array<{ id: string; name: string }>, void>({
      query: () => '/projects',
      providesTags: (result) =>
        result
          ? [...result.map(({ id }) => ({ type: 'Projects' as const, id })), { type: 'Projects', id: 'LIST' }]
          : [{ type: 'Projects', id: 'LIST' }],
    }),
    createProject: builder.mutation<{ id: string; name: string }, { name: string }>({
      query: (body) => ({
        url: '/projects',
        method: 'POST',
        body,
      }),
      invalidatesTags: [{ type: 'Projects', id: 'LIST' }],
    }),
  }),
});

export const { useGetProjectsQuery, useCreateProjectMutation } = apiSlice;
```

---

## 3. Unit Testing Redux Slices

```ts
// src/store/slices/authSlice.test.ts
import { describe, it, expect } from 'vitest';
import authReducer, { setCredentials, logout } from './authSlice';

describe('authSlice Reducer', () => {
  it('handles setCredentials correctly', () => {
    const initialState = { user: null, isAuthenticated: false, token: null };
    const user = { id: '1', email: 'belal@test.com', role: 'admin' as const };

    const state = authReducer(initialState, setCredentials({ user, token: 'jwt-123' }));

    expect(state.isAuthenticated).toBe(true);
    expect(state.user).toEqual(user);
    expect(state.token).toBe('jwt-123');
  });

  it('handles logout cleanly', () => {
    const activeState = {
      user: { id: '1', email: 'test@test.com', role: 'user' as const },
      isAuthenticated: true,
      token: 'jwt-123',
    };

    const state = authReducer(activeState, logout());

    expect(state.isAuthenticated).toBe(false);
    expect(state.user).toBeNull();
    expect(state.token).toBeNull();
  });
});
```

---

## Things to Avoid

- Never store non-serializable values (class instances, Promises, functions) inside Redux state.
- Avoid using untyped `useDispatch` and `useSelector` directly from `react-redux`.
- Avoid manually updating cache states without using RTK Query `providesTags`/`invalidatesTags`.
