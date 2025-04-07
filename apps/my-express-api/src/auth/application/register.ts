// src/auth/application/register.ts
import { injectable, inject } from "inversify";
import UserModel from "../infrastructure/models/User";
import * as firebaseAdmin from "firebase-admin";
import jwt from "jsonwebtoken";
import { Config } from "../../config/config";

@injectable()
export class RegisterUser {
  constructor(
    @inject(Config) private config: Config
  ) {}

  async execute(userData: any, profileImageBase64?: string) {
    try {
      let profileImageUrl = "NULL";
      
      if (profileImageBase64) {
        // Remove data URL prefix if present
        const base64Data = profileImageBase64.replace(/^data:image\/\w+;base64,/, '');
        
        const bucket = firebaseAdmin.storage().bucket();
        const fileName = `strive-tribe_profile_images/${Date.now()}_${Math.random().toString(36).substring(2, 8)}.jpg`;
        const file = bucket.file(fileName);
        
        const buffer = Buffer.from(base64Data, 'base64');
        
        await file.save(buffer, {
          metadata: {
            contentType: 'image/jpeg',
            metadata: {
              originalName: fileName,
              uploadedAt: new Date().toISOString()
            }
          }
        });
        
        await file.makePublic();
        profileImageUrl = `https://storage.googleapis.com/${bucket.name}/${fileName}`;
      }

      const newUser = new UserModel({ 
        userId: userData.user_id,
        email: userData.email,
        name: userData.name,
        gender: userData.gender,
        dateOfBirth: userData.dateOfBirth,
        location: userData.location,
        phoneNumber: userData.phone,
        profileImage: profileImageUrl,
        activities: userData.activities || [],
        signInWith: userData.signInWith,
        isVarified: userData.isVarified
      });
      
      await newUser.save();

      return {
        success: true,
        token: jwt.sign(
          { id: newUser._id },
          this.config.jwt_token_secret,
          { expiresIn: "30d" }
        ),
        user: {
          id: newUser._id,
          userId: newUser.userId,
          name: newUser.name,
          email: newUser.email,
          profileImage: newUser.profileImage,
          signInWith: newUser.signInWith,
          isVarified: newUser.isVarified
        }
      };
    } catch (error: any) {
      console.error("Registration error:", error);
      throw new Error(error.message || "Registration failed");
    }
  }
}