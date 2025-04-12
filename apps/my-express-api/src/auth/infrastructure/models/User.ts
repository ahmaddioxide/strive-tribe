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
  location: string;
  phoneNumber: string;
  profileImage?: string;
  activities: Activity[];
  signInWith: 'google' | 'facebook' | 'email_password';
  isVarified: boolean;
  scheduledActivities?: string[]; // Optional field for scheduled activities
  gamesPlayed?: number[]; // Optional field for games played
}

const UserSchema: Schema = new Schema({
  userId: { type: String, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  gender: { type: String, required: true },
  dateOfBirth: { type: String, required: true },
  location: { type: String, required: true },
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
  isVarified: { type: Boolean, default: false },
  scheduledActivities: [{ type: String, default: [] }],
  gamesPlayed: [{ type: Number, default: 0 }]
}, { timestamps: true });

export default mongoose.model<IUser>("User", UserSchema);