// src/request_activity/infrastructure/models/RequestActivity.ts
import mongoose, { Schema, Document } from "mongoose";
import { RequestActivity } from "../../domain/RequestActivity";

export interface IRequestActivity extends RequestActivity, Document {}

const RequestActivitySchema: Schema = new Schema({
  reqFrom: { type: String, required: true },
  reqTo: { type: String, required: true },
  activityId: { type: String, required: true },
  activityName: { type: String, required: true },
  activityLevel: { type: String, required: true },
  activityDate: { type: String, required: true },
  activityTime: { type: String, required: true },
  note: { type: String },
  videoUrl: { type: String },
  status: { type: String, enum: ['pending', 'accepted', 'declined'], default: 'pending' },
}, { timestamps: true });

export default mongoose.model<IRequestActivity>("RequestActivity", RequestActivitySchema);