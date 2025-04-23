import mongoose, { Schema, Document } from "mongoose";

export interface IParticipation extends Document {
  activityId: mongoose.Types.ObjectId;
  userId: string;
  joinedAt: Date;
  status: 'pending' | 'accepted' | 'decline';
}

const ParticipationSchema: Schema = new Schema({
  activityId: { 
    type: Schema.Types.ObjectId, 
    ref: 'Activity',
    required: true 
  },
  userId: { 
    type: Schema.Types.String, 
    ref: 'User',
    required: true 
  },
  status: {
    type: String,
    enum: ['pending', 'accepted', 'decline'],
    default: 'pending'
  },
  joinedAt: {
    type: Date,
    default: Date.now
  }
}, { timestamps: true });

// Prevent duplicate participation
//ParticipationSchema.index({ activityId: 1, userId: 1 }, { unique: true });

export default mongoose.model<IParticipation>("Participation", ParticipationSchema);