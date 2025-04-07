// src/auth/application/update.ts
import { injectable, inject } from "inversify";
import UserModel from "../infrastructure/models/User";
import * as firebaseAdmin from "firebase-admin";
import { Config } from "../../config/config";

@injectable()
export class UpdateUser {
  constructor(
    @inject(Config) private config: Config
  ) {}

  async execute(userId: string, updateData: any, profileImageBase64?: string) {
    try {
      const user = await UserModel.findOne({ userId });
      if (!user) {
        throw new Error("User not found");
      }

      let profileImageUrl = user.profileImage;
      const bucket = firebaseAdmin.storage().bucket();

      // Handle profile image update
      if (profileImageBase64) {
        // Delete old image if exists
        if (user.profileImage && user.profileImage !== "NULL") {
          const oldFileName = user.profileImage.split('/').pop();
          const oldFile = bucket.file(`strive-tribe_profile_images/${oldFileName}`);
          await oldFile.delete().catch(error => {
            console.error("Error deleting old profile image:", error);
          });
        }

        // Upload new image
        const base64Data = profileImageBase64.replace(/^data:image\/\w+;base64,/, '');
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

      // Build update object
      const updateObject = {
        ...(updateData.name && { name: updateData.name }),
        ...(updateData.email && { email: updateData.email }),
        ...(updateData.location && { location: updateData.location }),
        ...(updateData.phone && { phoneNumber: updateData.phone }),
        ...(updateData.dateOfBirth && { dateOfBirth: updateData.dateOfBirth }),
        ...(updateData.gender && { gender: updateData.gender }),
        ...(updateData.activities && { activities: updateData.activities }),
        profileImage: profileImageUrl,
        ...(updateData.isVarified !== undefined && { isVarified: updateData.isVarified })
      };

      const updatedUser = await UserModel.findOneAndUpdate(
        { userId },
        updateObject,
        { new: true, runValidators: true }
      ).lean();

      if (!updatedUser) {
        throw new Error("User update failed");
      }

      return {
        success: true,
        user: {
          id: updatedUser._id,
          userId: updatedUser.userId,
          name: updatedUser.name,
          email: updatedUser.email,
          profileImage: updatedUser.profileImage,
          location: updatedUser.location,
          phoneNumber: updatedUser.phoneNumber,
          dateOfBirth: updatedUser.dateOfBirth,
          gender: updatedUser.gender,
          activities: updatedUser.activities,
          signInWith: updatedUser.signInWith,
          isVarified: updatedUser.isVarified
        }
      };
    } catch (error: any) {
      console.error("Update error:", error);
      throw new Error(error.message || "User update failed");
    }
  }
}