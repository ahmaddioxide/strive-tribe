// src/auth/application/update.ts
import { injectable, inject } from "inversify";
import UserModel from "../infrastructure/models/User";
import * as firebaseAdmin from "firebase-admin";
import { Config } from "../../config/config";
import axios from "axios";

@injectable()
export class UpdateUser {
  constructor(
    @inject(Config) private config: Config
  ) {}

  private async fetchLocationDetails(postalCode: string) {
    try {
      const response = await axios.get(`http://api.zippopotam.us/us/${postalCode}`);
      const data = response.data;
      
      if (!data.places || data.places.length === 0) {
        throw new Error("No location data found for this postal code");
      }

      const place = data.places[0];
      return {
        placeName: place["place name"],
        countryName: data.country,
        longitude: place.longitude,
        latitude: place.latitude,
        state: place.state
      };
    } catch (error: any) {
      console.error("Error fetching location details:", error);
      throw new Error("Failed to fetch location details for the provided postal code");
    }
  }

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
        const buffer = Buffer.from(base64Data, 'base64');

        // Check if image exceeds 100MB
        const maxSize = 100 * 1024 * 1024; // 100MB in bytes
        if (buffer.length > maxSize) {
          throw new Error("Profile image size exceeds the 100MB limit.");
        }

        const fileName = `strive-tribe_profile_images/${Date.now()}_${Math.random().toString(36).substring(2, 8)}.jpg`;
        const file = bucket.file(fileName);

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

      // Initialize update object with basic fields
      const updateObject: any = {
        ...(updateData.name && { name: updateData.name }),
        ...(updateData.email && { email: updateData.email }),
        ...(updateData.phone && { phoneNumber: updateData.phone }),
        ...(updateData.dateOfBirth && { dateOfBirth: updateData.dateOfBirth }),
        ...(updateData.gender && { gender: updateData.gender }),
        ...(updateData.activities && { activities: updateData.activities }),
        profileImage: profileImageUrl,
        ...(updateData.isVerified !== undefined && { isVerified: updateData.isVerified }),
        ...(updateData.deviceToken && { deviceToken: updateData.deviceToken })
      };

      // Special handling for postalCode - update all location fields together
      if (updateData.postalCode) {
        if (updateData.postalCode !== user.postalCode) {
          // Only fetch new location if postalCode actually changed
          const locationDetails = await this.fetchLocationDetails(updateData.postalCode);
          
          updateObject.postalCode = updateData.postalCode;
          updateObject.placeName = locationDetails.placeName;
          updateObject.countryName = locationDetails.countryName;
          updateObject.longitude = locationDetails.longitude;
          updateObject.latitude = locationDetails.latitude;
          updateObject.state = locationDetails.state;
        }
      } else if (
        updateData.placeName || 
        updateData.countryName || 
        updateData.longitude || 
        updateData.latitude || 
        updateData.state
      ) {
        // Prevent partial location updates if postalCode isn't provided
        throw new Error("Cannot update location fields without providing postalCode");
      }

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
          postalCode: updatedUser.postalCode,
          placeName: updatedUser.placeName,
          countryName: updatedUser.countryName,
          longitude: updatedUser.longitude,
          latitude: updatedUser.latitude,
          state: updatedUser.state,
          phoneNumber: updatedUser.phoneNumber,
          dateOfBirth: updatedUser.dateOfBirth,
          gender: updatedUser.gender,
          activities: updatedUser.activities,
          signInWith: updatedUser.signInWith,
          isVerified: updatedUser.isVerified,
          deviceToken: updatedUser.deviceToken
        }
      };
    } catch (error: any) {
      console.error("Update error:", error);
      throw new Error(error.message || "User update failed");
    }
  }
}