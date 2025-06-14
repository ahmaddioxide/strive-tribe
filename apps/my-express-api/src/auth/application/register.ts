// src/auth/application/register.ts
import { injectable, inject } from "inversify";
import UserModel from "../infrastructure/models/User";
import * as firebaseAdmin from "firebase-admin";
import jwt from "jsonwebtoken";
import { Config } from "../../config/config";
import axios from "axios";
import nodemailer from "nodemailer";

@injectable()
export class RegisterUser {
  constructor(
    @inject(Config) private config: Config
  ) {}

  private async fetchLocationDetails(postalCode: string) {
    try {
      const response = await axios.get(
        `https://maps.googleapis.com/maps/api/geocode/json?address=${postalCode}&key=${this.config.googleMapsApiKey}`
      );

      const data = response.data;

      if (data.status !== 'OK' || data.results.length === 0) {
        throw new Error("No location data found for this postal code");
      }

      const result = data.results[0];
      const location = result.geometry.location;

      let placeName = '';
      let state = '';
      let countryName = '';
      let countryShortName = '';

      for (const component of result.address_components) {
        if (component.types.includes('locality')) {
          placeName = component.long_name;
        }
        if (component.types.includes('administrative_area_level_1')) {
          state = component.long_name;
        }
        if (component.types.includes('country')) {
          countryName = component.long_name;
          countryShortName = component.short_name;
        }
      }

      if (countryShortName !== 'US') {
        throw new Error("Postal code does not exist in the United States.");
      }

      return {
        placeName,
        countryName,
        longitude: location.lng.toString(),
        latitude: location.lat.toString(),
        state
      };
    } catch (error: any) {
      console.error("Error fetching location details:", error.message);
      throw new Error(error.message || "Failed to fetch location details for the provided postal code");
    }
  }

  async execute(userData: any, profileImageBase64?: string) {
    try {
      const userId = userData.user_id;
      const firebase = this.config.initializeFirebase();

      // try {
      //   await firebase.auth().getUser(userId);
      // } catch (error: any) {
      //   if (error.code === 'auth/user-not-found') {
      //     throw new Error('User not registered in Firebase. Please authenticate first.');
      //   }
      //   throw new Error(`Firebase verification failed: ${error.message}`);
      // }
      let firebaseUserExists = false;
      try {
        await firebase.auth().getUser(userId);
        firebaseUserExists = true;
      } catch (error: any) {
        if (error.code === 'auth/user-not-found') {
          throw new Error('User not registered in Firebase. Please authenticate first.');
        }
        throw new Error(`Firebase verification failed: ${error.message}`);
      }

      //const locationDetails = await this.fetchLocationDetails(userData.postalCode);

      let locationDetails
      try {
        locationDetails = await this.fetchLocationDetails(userData.postalCode);
      } catch (error: any) {
        if (firebaseUserExists) {
          try {
            await firebase.auth().deleteUser(userId);
            console.log(`Firebase user ${userId} deleted due to invalid postal code`);
          } catch (deleteError) {
            console.error(`Failed to delete Firebase user ${userId}:`, deleteError);
          }
        }
        throw new Error(error.message || "Invalid postal code");
      }

      let profileImageUrl = "NULL";

      if (profileImageBase64) {
        const base64Data = profileImageBase64.replace(/^data:image\/\w+;base64,/, '');
        const buffer = Buffer.from(base64Data, 'base64');

        const maxSize = 100 * 1024 * 1024;
        if (buffer.length > maxSize) {
          throw new Error("Profile image size exceeds the 100MB limit.");
        }

        const bucket = firebaseAdmin.storage().bucket();
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

      


      const newUser = new UserModel({
        userId: userData.user_id,
        email: userData.email,
        name: userData.name,
        gender: userData.gender,
        dateOfBirth: userData.dateOfBirth,
        postalCode: userData.postalCode,
        placeName: locationDetails.placeName,
        countryName: locationDetails.countryName,
        longitude: locationDetails.longitude,
        latitude: locationDetails.latitude,
        state: locationDetails.state,
        phoneNumber: userData.phone,
        profileImage: profileImageUrl,
        activities: userData.activities || [],
        signInWith: userData.signInWith,
        isVerified: userData.isVerified
      });

      await newUser.save();

      // Send Welcome Email
      const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
          user: 'muhammadyounasqayyum009@gmail.com',
          pass: this.config.gmailAppPassword // ✅ Put this in .env
        }
      });

      const mailOptions = {
        from: '"Strive Tribe" <muhammadyounasqayyum009@gmail.com>',
        to: newUser.email,
        subject: 'Welcome to Strive Tribe!',
        html: `
          <h2>Welcome to Strive Tribe, ${newUser.name}!</h2>
          <p>We’re thrilled to have you join our community. 🎉</p>
          <p>Start exploring new activities, meet like-minded people, and grow your tribe!</p>
          <br />
          <p>Stay connected,</p>
          <p><strong>Strive Tribe Team</strong></p>
        `
      };

      try {
        await transporter.sendMail(mailOptions);
        console.log(`Welcome email sent to ${newUser.email}`);
      } catch (emailError) {
        console.error('Failed to send welcome email:', emailError);
      }

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
          postalCode: newUser.postalCode,
          placeName: newUser.placeName,
          countryName: newUser.countryName,
          longitude: newUser.longitude,
          latitude: newUser.latitude,
          state: newUser.state,
          phoneNumber: newUser.phoneNumber,
          profileImage: newUser.profileImage,
          signInWith: newUser.signInWith,
          isVerified: newUser.isVerified
        }
      };
    } catch (error: any) {
      console.error("Registration error:", error.message);
      throw new Error(error.message || "Registration failed");
    }
  }
}
