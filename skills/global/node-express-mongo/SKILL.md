---
name: node-express-mongo
description: Architecture standards and implementation patterns for Node.js, Express, and MongoDB/Mongoose backends with TypeScript. Use when building REST APIs, controllers, domain services, Mongoose models/schemas, generic repositories, Zod validation, or unit testing MERN backends.
---

# Node.js, Express & Mongoose Clean Architecture Guide

## When to use this skill
Trigger whenever building, refactoring, or testing Node.js Express backends with MongoDB and Mongoose in TypeScript.

---

## 1. Architectural Layers & Responsibilities

```
[HTTP Request] ──► [Zod Validation Middleware]
                           │
                  [Express Controller] ──► Extracts params/body, returns HTTP Status & Envelope
                           │
                  [Domain Service]     ──► Business rules, orchestration, returns Result<T, Error>
                           │
                  [Repository Layer]   ──► Mongoose queries (find, create, update, delete)
                           │
                  [MongoDB Database]
```

- **Controllers never touch Mongoose models directly.**
- **Services never handle raw `req` or `res` Express objects.**
- **Mongoose models and schemas live strictly inside the Repository/Data layer.**

---

## 2. Production Code Implementation

### A. Mongoose Schema & Typed Document
```ts
// src/features/users/user.model.ts
import mongoose, { Document, Schema, Model } from 'mongoose';

// 1. Plain Data Contract
export interface IUser {
  email: string;
  fullName: string;
  role: 'admin' | 'user';
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

// 2. Mongoose Document Interface
export interface IUserDocument extends IUser, Document {}

// 3. Schema Definition with Generic
export const UserSchema = new Schema<IUserDocument>(
  {
    email: {
      type: String,
      required: [true, 'Email is required'],
      unique: true,
      trim: true,
      lowercase: true,
      index: true,
    },
    fullName: {
      type: String,
      required: [true, 'Full name is required'],
      trim: true,
      maxlength: [100, 'Name cannot exceed 100 characters'],
    },
    role: {
      type: String,
      enum: ['admin', 'user'],
      default: 'user',
    },
    isActive: {
      type: Boolean,
      default: true,
    },
  },
  { timestamps: true }
);

export const UserModel: Model<IUserDocument> = mongoose.model<IUserDocument>('User', UserSchema);
```

### B. Repository Layer
```ts
// src/features/users/user.repository.ts
import { UserModel, type IUserDocument, type IUser } from './user.model';

export interface IUserRepository {
  findById(id: string): Promise<IUserDocument | null>;
  findByEmail(email: string): Promise<IUserDocument | null>;
  create(userData: Partial<IUser>): Promise<IUserDocument>;
  update(id: string, updateData: Partial<IUser>): Promise<IUserDocument | null>;
  delete(id: string): Promise<boolean>;
}

export class MongoUserRepository implements IUserRepository {
  async findById(id: string): Promise<IUserDocument | null> {
    return UserModel.findById(id).exec();
  }

  async findByEmail(email: string): Promise<IUserDocument | null> {
    return UserModel.findOne({ email: email.toLowerCase() }).exec();
  }

  async create(userData: Partial<IUser>): Promise<IUserDocument> {
    return UserModel.create(userData);
  }

  async update(id: string, updateData: Partial<IUser>): Promise<IUserDocument | null> {
    return UserModel.findByIdAndUpdate(id, updateData, { new: true, runValidators: true }).exec();
  }

  async delete(id: string): Promise<boolean> {
    const result = await UserModel.findByIdAndDelete(id).exec();
    return !!result;
  }
}
```

### C. Domain Service Layer with `Result<T, E>`
```ts
// src/features/users/user.service.ts
import type { IUserRepository } from './user.repository';
import type { IUser } from './user.model';

export type Result<T, E = string> = 
  | { success: true; data: T }
  | { success: false; error: E; code?: number };

export class UserService {
  constructor(private readonly userRepository: IUserRepository) {}

  async registerUser(input: { email: string; fullName: string }): Promise<Result<IUser>> {
    const existingUser = await this.userRepository.findByEmail(input.email);
    if (existingUser) {
      return { success: false, error: 'Email is already registered', code: 409 };
    }

    const newUser = await this.userRepository.create({
      email: input.email,
      fullName: input.fullName,
      role: 'user',
      isActive: true,
    });

    return { success: true, data: newUser };
  }

  async getUserById(id: string): Promise<Result<IUser>> {
    const user = await this.userRepository.findById(id);
    if (!user) {
      return { success: false, error: 'User not found', code: 404 };
    }
    return { success: true, data: user };
  }
}
```

### D. Express Controller & Zod Validation
```ts
// src/features/users/user.controller.ts
import { Request, Response, NextFunction } from 'express';
import { UserService } from './user.service';
import { z } from 'zod';

export const CreateUserSchema = z.object({
  body: z.object({
    email: z.string().email('Invalid email address'),
    fullName: z.string().min(2, 'Name must be at least 2 characters'),
  }),
});

export class UserController {
  constructor(private readonly userService: UserService) {}

  register = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await this.userService.registerUser(req.body);
      if (!result.success) {
        res.status(result.code || 400).json({ success: false, message: result.error });
        return;
      }
      res.status(201).json({ success: true, data: result.data });
    } catch (error) {
      next(error);
    }
  };
}
```

### E. Global Error Handling Middleware
```ts
// src/middleware/errorHandler.ts
import { Request, Response, NextFunction } from 'express';

export function errorHandler(
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction
): void {
  console.error('[Unhandled Server Error]:', err.stack || err.message);

  res.status(500).json({
    success: false,
    message: process.env.NODE_ENV === 'production' ? 'Internal server error' : err.message,
  });
}
```

---

## 3. Unit Testing the Service Layer

```ts
// tests/unit/user.service.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { UserService } from '../../src/features/users/user.service';
import type { IUserRepository } from '../../src/features/users/user.repository';

describe('UserService', () => {
  let mockRepo: IUserRepository;
  let service: UserService;

  beforeEach(() => {
    mockRepo = {
      findById: vi.fn(),
      findByEmail: vi.fn(),
      create: vi.fn(),
      update: vi.fn(),
      delete: vi.fn(),
    };
    service = new UserService(mockRepo);
  });

  it('registers user when email is available', async () => {
    vi.mocked(mockRepo.findByEmail).mockResolvedValue(null);
    vi.mocked(mockRepo.create).mockResolvedValue({
      id: 'usr_1',
      email: 'alex@example.com',
      fullName: 'Alex Ray',
    } as any);

    const result = await service.registerUser({ email: 'alex@example.com', fullName: 'Alex Ray' });

    expect(result.success).toBe(true);
    if (result.success) {
      expect(result.data.email).toBe('alex@example.com');
    }
  });
});
```

---

## Things to Avoid

- Never query Mongoose models (`UserModel.find()`) inside Express router or controller files.
- Never pass untyped `any` objects to Mongoose schemas.
- Avoid swallowing errors in controllers without forwarding them via `next(error)`.
- Never execute unindexed queries in production MongoDB collections.
