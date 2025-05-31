//src/chat/application/ChatService.ts
import { injectable } from 'inversify';
import MessageModel from '../infrastructure/models/Message';
import ConversationModel from '../infrastructure/models/Conversation';
import ChatRoomModel from '../infrastructure/models/ChatRoom';
import UserModel from '../../auth/infrastructure/models/User';
import crypto from 'crypto';

@injectable()
export class ChatService {
  // 🔹 Send a message from sender to recipient
  async sendMessage(senderId: string, recipientId: string, content: string) {
    if (senderId === recipientId)
      throw new Error('Cannot send message to yourself');

    const recipient = await UserModel.findOne({ userId: recipientId });
    if (!recipient) throw new Error('Recipient not found');

    // Get or create chat room
    const room = await this.getOrCreateRoom(senderId, recipientId);

    const message = new MessageModel({
      roomId: room._id,
      senderId,
      recipientId,
      content,
    });
    await message.save();

    const participants = [senderId, recipientId].sort();
    await ConversationModel.findOneAndUpdate(
      { participants },
      {
        lastMessage: content,
        lastMessageTimestamp: new Date(),
        $inc: { unreadCount: 1 },
      },
      { upsert: true, new: true }
    );

    return message;
  }

  // 🔹 Get all conversations for a user
  async getConversations(userId: string) {
    return ConversationModel.find({ participants: userId }).sort(
      '-lastMessageTimestamp'
    );
  }

  async getMessages(userId: string, recipientId: string) {
    const room = await ChatRoomModel.findOne({
        participants: { $all: [userId, recipientId] }
    });

    if (!room) {
        console.log('No room found for users:', userId, recipientId);
        return [];
    }

    console.log('Room found:', room._id);

    const messages = await MessageModel.find({ roomId: room._id }).sort('timestamp');
    console.log(`Found ${messages.length} messages`);
    return messages;
  }
  // 🔹 Mark messages as read
  async markMessagesAsRead(userId: string, otherUserId: string) {
    const participants = [userId, otherUserId].sort();
    const room = await ChatRoomModel.findOne({ participants });
    if (!room) return;

    await MessageModel.updateMany(
      {
        roomId: room._id,
        read: false,
        $or: [
          { senderId: userId, recipientId: otherUserId },
          { senderId: otherUserId, recipientId: userId },
        ],
      },
      { $set: { read: true } }
    );
  }


  // 🔹 Enriched chat list for frontend display
  async getChatList(userId: string) {
    const conversations = await ConversationModel.find({
      participants: userId,
    }).sort('-lastMessageTimestamp');

    const enrichedConversations = await Promise.all(
      conversations.map(async (conv) => {
        const recipientId = conv.participants.find(
          (id: string) => id !== userId
        );
        const recipient = await UserModel.findOne({
          userId: recipientId,
        }).select('userId name profileImage');

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

  // 🔹 Get or create a unique chat room between two users
  async getOrCreateRoom(senderId: string, recipientId: string) {
    const participants = [senderId, recipientId].sort();
    let room = await ChatRoomModel.findOne({ participants });

    if (!room) {
      room = new ChatRoomModel({ participants });
      await room.save();
    }

    return room;
  }
}
