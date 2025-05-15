//src/auth/infrastructure/models/User.ts
import mongoose, { Schema, Document } from "mongoose";

interface Activity {
  name: string;
  expertise_level: string;
}

export interface IUser extends Document {
  userId: string;
  email: string;
  name: string;
  gender: string;
  dateOfBirth: string;
  location: number;
  phoneNumber: string;
  profileImage?: string;
  activities: Activity[];
  signInWith: 'google' | 'facebook' | 'email_password';
  isVerified: boolean;
  scheduledActivities?: string; 
  gamesPlayed?: number;
  placeName?: string;
  countryName?: string;
  longitude?: string;
  latitude?: string;
  state?: string;
  postalCode?: string;
  deviceToken?: string;

}

const UserSchema: Schema = new Schema({
  userId: { type: String, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  gender: { type: String, required: true },
  dateOfBirth: { type: String, required: true },
  phoneNumber: { type: String, required: true },
  profileImage: { type: String },
  activities: [{
    name: String,
    expertise_level: String
  }],
  signInWith: {
    type: String,
    enum: ['google', 'facebook', 'email_password'],
    required: true
  },
  isVerified: { type: Boolean, default: false },
  scheduledActivities: [{
    userId: { type: String },
    activityId: { type: String },
    activity: { type: String },
    partnerName: { type: String },
    playerLevel: { type: String },
    date: { type: String },
    time: { type: String }
  }],
  gamesPlayed: { type: Number, default: 0 },
  placeName: { type: String },
  countryName: { type: String },
  longitude: { type: String },
  latitude: { type: String },
  deviceToken: { type: String, default: "" },
  state: { type: String },
  postalCode: { type: String, required: true },

}, { timestamps: true });

export default mongoose.model<IUser>("User", UserSchema);