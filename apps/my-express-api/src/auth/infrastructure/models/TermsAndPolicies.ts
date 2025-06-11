// src/auth/infrastructure/models/TermsAndPolicies.ts
import mongoose, { Schema, Document } from "mongoose";

interface ITerms extends Document {
  version: string;
  content: string;
  effectiveDate: Date;
}

const TermsSchema: Schema = new Schema({
  version: { type: String, required: true },
  content: { type: String, required: true },
  effectiveDate: { type: Date, required: true }
}, {
  timestamps: true,
  collection: "terms_and_policies"
});

export default mongoose.model<ITerms>("TermsAndPolicies", TermsSchema);