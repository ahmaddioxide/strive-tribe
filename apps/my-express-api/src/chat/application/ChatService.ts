import { injectable } from 'inversify';
import MessageModel from '../infrastructure/models/Message';
import ConversationModel from '../infrastructure/models/Conversation';
import ChatRoomModel from '../infrastructure/models/ChatRoom';
import UserModel from '../../auth/infrastructure/models/User';

@injectable()
export class ChatService {
  async sendMessage(senderId: string, recipientId: string, content: string) {
    if (senderId === recipientId)
      throw new Error('Cannot send message to yourself');

    const recipient = await UserModel.findOne({ userId: recipientId });
    if (!recipient) throw new Error('Recipient not found');

    const room = await this.getOrCreateRoom(senderId, recipientId);

    const message = new MessageModel({
      roomId: room._id,
      senderId,
      recipientId,
      content,
    });
    await message.save();

    const participants = [senderId, recipientId].sort();

    let conversation = await ConversationModel.findOne({ participants });

    if (!conversation) {
      // First time creating conversation
      const unreadCounts = new Map<string, number>();
      unreadCounts.set(senderId, 0);
      unreadCounts.set(recipientId, 1);

      conversation = new ConversationModel({
        participants,
        lastMessage: content,
        lastMessageTimestamp: new Date(),
        unreadCounts,
      });
      await conversation.save();
    } else {
      // Update existing conversation
      let currentCount = 0;
      if (conversation.unreadCounts instanceof Map) {
        currentCount = conversation.unreadCounts.get(recipientId) || 0;
        conversation.unreadCounts.set(recipientId, currentCount + 1);
      } else if (conversation.unreadCounts && typeof conversation.unreadCounts === 'object') {
        currentCount = conversation.unreadCounts[recipientId] || 0;
        conversation.unreadCounts[recipientId] = currentCount + 1;
      }
      conversation.lastMessage = content;
      conversation.lastMessageTimestamp = new Date();
      await conversation.save();
    }

    return message;
  }

  async getConversations(userId: string) {
    return ConversationModel.find({ participants: userId }).sort(
      '-lastMessageTimestamp'
    );
  }

  async getMessages(userId: string, recipientId: string) {
    const room = await ChatRoomModel.findOne({
      participants: { $all: [userId, recipientId] },
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

  async markMessagesAsRead(userId: string, otherUserId: string) {
    const participants = [userId, otherUserId].sort();
    const room = await ChatRoomModel.findOne({ participants });
    if (!room) return;

    await MessageModel.updateMany(
      {
        roomId: room._id,
        read: false,
        $or: [{ senderId: otherUserId, recipientId: userId }],
      },
      { $set: { read: true } }
    );

    await ConversationModel.findOneAndUpdate(
      { participants },
      { $set: { [`unreadCounts.${userId}`]: 0 } }
    );
  }

  async getChatList(userId: string) {
    const conversations = await ConversationModel.find({
      participants: userId,
    }).sort('-lastMessageTimestamp');

    const enrichedConversations = await Promise.all(
      conversations.map(async (conv) => {
        const recipientId = conv.participants.find((id: string) => id !== userId);
        const recipient = await UserModel.findOne({
          userId: recipientId,
        }).select('userId name profileImage');

        return {
          _id: conv._id,
          lastMessage: conv.lastMessage,
          lastMessageTimestamp: conv.lastMessageTimestamp,
          unreadCount:
            conv.unreadCounts instanceof Map
              ? conv.unreadCounts.get(userId) || 0
              : conv.unreadCounts?.[userId] || 0,
          recipient,
        };
      })
    );

    return enrichedConversations;
  }

  async getOrCreateRoom(senderId: string, recipientId: string) {
    const participants = [senderId, recipientId].sort();
    let room = await ChatRoomModel.findOne({ participants });

    if (!room) {
      room = new ChatRoomModel({ participants });
      console.log("room baby", room);
      await room.save();
    }

    return room;
  }
}
