// src/activity/infrastructure/models/Activity.ts
import mongoose, { Schema, Document } from "mongoose";
import { Activity } from "../../domain/Activity";

export interface IActivity extends Activity, Document {}

const ActivitySchema: Schema = new Schema({
  userId: { type: String, required: true },
  selectActivity: { type: String, required: true },
  selectPlayerLevel: { type: String, required: true },
  selectDate: { type: String, required: true },
  selectTime: { type: String, required: true },
  notes: { type: String },
  videoUrl: { type: String, required: true },
}, { timestamps: true });

export default mongoose.model<IActivity>("Activity", ActivitySchema);