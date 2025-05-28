import mongoose, { Schema, Document } from "mongoose";

export interface IConversation extends Document {
    participants: string[];
    lastMessage: string;
    lastMessageTimestamp: Date;
    unreadCount: number;
}

const ConversationSchema: Schema = new Schema({
    participants: { type: [String], required: true },
    lastMessage: { type: String, required: true },
    lastMessageTimestamp: { type: Date, default: Date.now },
    unreadCount: { type: Number, default: 0 }
});

ConversationSchema.index({ participants: 1 }, { unique: true });

export default mongoose.model<IConversation>("Conversation", ConversationSchema);