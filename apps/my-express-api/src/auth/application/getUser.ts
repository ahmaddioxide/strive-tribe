// src/auth/application/getUser.ts
import { injectable } from "inversify";
import UserModel from "../infrastructure/models/User";

@injectable()
export class GetUser {
  async execute(userId: string) {
    
    const user = await UserModel.findOne({ userId })
      .select('-__v -createdAt -updatedAt') // Exclude unnecessary fields
      .lean();
    
    if (!user) {
      throw new Error("User not found");
    }
    
    // Convert MongoDB ObjectId to string
    if (user._id) {
      user.id = user._id.toString();
      delete user._id;
    }
    
    return user;
  }
}