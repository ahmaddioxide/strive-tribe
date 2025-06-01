// src/activity/infrastructure/models/Activity.ts
import mongoose, { Schema, Document } from "mongoose";
import { Activity } from "../../domain/Activity";

export interface IActivity extends Activity, Document {}

const ActivitySchema: Schema = new Schema({
  userId: { type: String, required: true },
  Activity: { type: String, required: true },
  PlayerLevel: { type: String, required: true },
  Date: { type: String, required: true },
  Time: { type: String, required: true },
  notes: { type: String },
  videoUrl: { type: String },
}, { timestamps: true });

export default mongoose.model<IActivity>("Activity", ActivitySchema);