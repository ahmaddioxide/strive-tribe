import mongoose, { Schema, Document } from "mongoose";

export interface IConversation extends Document {
  participants: string[];
  lastMessage: string;
  lastMessageTimestamp: Date;
  unreadCounts: { [userId: string]: number };
}

const ConversationSchema: Schema = new Schema({
  participants: { type: [String], required: true },
  lastMessage: { type: String, required: true },
  lastMessageTimestamp: { type: Date, default: Date.now },
  unreadCounts: {
    type: Map,
    of: Number,
    default: {},
  },
});

export default mongoose.model<IConversation>("Conversation", ConversationSchema);
