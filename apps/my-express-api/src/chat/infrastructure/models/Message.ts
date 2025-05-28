import mongoose, { Schema, Document } from "mongoose";

export interface IMessage extends Document {
    senderId: string;
    recipientId: string;
    content: string;
    timestamp: Date;
    read: boolean;
}

const MessageSchema: Schema = new Schema({
    senderId: { type: String, required: true },
    recipientId: { type: String, required: true },
    content: { type: String, required: true },
    timestamp: { type: Date, default: Date.now },
    read: { type: Boolean, default: false }
});

export default mongoose.model<IMessage>("Message", MessageSchema);