// src/auth/application/check.ts
import { injectable } from "inversify";
import UserModel from "../infrastructure/models/User";

@injectable()
export class CheckUser {
  async execute(userId: string): Promise<boolean> {
    
    const user = await UserModel.findOne({ userId });
    return !!user;
  }
}