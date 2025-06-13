// src/auth/infrastructure/models/ProblemReport.ts
import mongoose, { Schema, Document } from "mongoose";

interface IProblemReport extends Document {
  name: string;
  email: string;
  description: string;
  resolved: boolean;
  resolvedAt?: Date;
  createdAt?: Date;
  updatedAt?: Date;
}

const ProblemReportSchema: Schema = new Schema({
  name: { 
    type: String, 
    required: [true, "Name is required"] 
  },
  email: { 
    type: String, 
    required: [true, "Email is required"],
    match: [/^\S+@\S+\.\S+$/, "Please use a valid email address"]
  },
  description: { 
    type: String, 
    required: [true, "Description is required"],
    minlength: [5, "Description should be at least 5 characters"]
  },
  resolved: {
    type: Boolean,
    default: false
  },
  resolvedAt: {
    type: Date,
    default: null
  }
}, {
  timestamps: true,
  collection: "problem_reports"
});

export default mongoose.model<IProblemReport>("ProblemReport", ProblemReportSchema);