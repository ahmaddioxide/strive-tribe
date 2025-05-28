//src/chat/application/ChatService.ts
import { injectable } from "inversify";
import MessageModel from "../infrastructure/models/Message";
import ConversationModel from "../infrastructure/models/Conversation";
import UserModel from "../../auth/infrastructure/models/User";

@injectable()
export class ChatService {
    async sendMessage(senderId: string, recipientId: string, content: string) {
        if (senderId === recipientId) throw new Error("Cannot send message to yourself");
        
        const recipient = await UserModel.findOne({ userId: recipientId });
        if (!recipient) throw new Error("Recipient not found");

        const message = new MessageModel({ senderId, recipientId, content });
        await message.save();

        const participants = [senderId, recipientId].sort();
        await ConversationModel.findOneAndUpdate(
            { participants },
            { 
                lastMessage: content,
                lastMessageTimestamp: new Date(),
                $inc: { unreadCount: 1 }
            },
            { upsert: true, new: true }
        );

        return message;
    }

    async getConversations(userId: string) {
        return ConversationModel.find({ participants: userId }).sort("-lastMessageTimestamp");
    }

    async getMessages(userId: string, recipientId: string) {
        return MessageModel.find({
            $or: [
                { senderId: userId, recipientId },
                { senderId: recipientId, recipientId: userId }
            ]
        }).sort("timestamp");
    }

    async markMessagesAsRead(userId: string, recipientId: string) {
        await MessageModel.updateMany(
            { recipientId: userId, senderId: recipientId, read: false },
            { $set: { read: true } }
        );
    }

    async getChatList(userId: string) {
    const conversations = await ConversationModel.find({ participants: userId }).sort("-lastMessageTimestamp");

    const enrichedConversations = await Promise.all(
        conversations.map(async (conv) => {
            const recipientId = conv.participants.find((id: string) => id !== userId);
            const recipient = await UserModel.findOne({ userId: recipientId }).select("userId name profileImage");

            return {
                _id: conv._id,
                lastMessage: conv.lastMessage,
                lastMessageTimestamp: conv.lastMessageTimestamp,
                unreadCount: conv.unreadCount,
                recipient,
            };
        })
    );

        return enrichedConversations;
    }
}