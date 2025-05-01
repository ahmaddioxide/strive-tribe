// src/notifications/infrastructure/models/Notification.ts
import mongoose, { Schema, Document } from "mongoose";

export interface INotification extends Document {
  userId: string;
  title: string;
  message: string;
  profileImage?: string;
  activityId: string;
  requesterId: string;
  activityDate?: string;
  activityTime?: string;
  read: boolean;
  status?: string;
}

const NotificationSchema = new Schema({
  userId: { type: String, required: true },
  title: { type: String, required: true },
  message: { type: String, required: true },
  profileImage: { type: String },
  activityId: { type: String, required: true },
  requesterId: { type: String, required: true },
  activityDate: { type: String },
  activityTime: { type: String },
  read: { type: Boolean, default: false },
  status: { type: String, enum: ['pending', 'accepted', 'declined'], default: 'pending' },
}, { timestamps: true });

export default mongoose.model<INotification>("Notification", NotificationSchema);