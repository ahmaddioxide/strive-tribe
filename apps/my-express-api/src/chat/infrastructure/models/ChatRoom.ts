// src/chat/infrastructure/models/ChatRoom.ts
import mongoose, { Schema, Document } from 'mongoose';

export interface IChatRoom extends Document {
  participants: string[]; // array of userIds (2 participants)
  createdAt: Date;
  updatedAt: Date;
}

const ChatRoomSchema: Schema = new Schema(
  {
    participants: {
      type: [String],
      required: true,
      validate: [(val: string[]) => val.length === 2, 'Participants must be exactly 2'],
      index: true,
    },
  },
  { timestamps: true }
);

export default mongoose.model<IChatRoom>('ChatRoom', ChatRoomSchema);
