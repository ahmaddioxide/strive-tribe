//src/chat/interface/http/chat.controller.ts
import { Router, Request, Response } from 'express';
import { injectable, inject } from 'inversify';
import IController from '../../../auth/interface/http/IController';
import { authenticate } from '../../../auth/interface/middleware/auth';
import { ChatService } from '../../application/ChatService';
import { Config } from '../../../config/config';
import * as socketio from 'socket.io';

@injectable()
export class ChatController implements IController {
  public path = '/chat';
  public router: Router = Router();
  private io?: socketio.Server;

  constructor(
    @inject(ChatService) private chatService: ChatService,
    @inject(Config) private config: Config
  ) {
    this.initializeRoutes();
  }

  public setIo(io: socketio.Server) {
    this.io = io;
  }

  private initializeRoutes() {
    this.router.post(
      `${this.path}/messages`,
      authenticate,
      this.sendMessage.bind(this)
    );
    this.router.get(
      `${this.path}/conversations`,
      authenticate,
      this.getConversations.bind(this)
    );
    this.router.get(
      `${this.path}/messages/:recipientId`,
      authenticate,
      this.getMessages.bind(this)
    );
    this.router.put(
      `${this.path}/messages/read/:recipientId`,
      authenticate,
      this.markAsRead.bind(this)
    );
    this.router.get(
      `${this.path}/chat-lists`,
      authenticate,
      this.getChatList.bind(this)
    );
    this.router.get(
      `${this.path}/room`,
      authenticate,
      this.getOrCreateRoom.bind(this)
    );
  }

  private async sendMessage(req: Request, res: Response) {
    try {
      //const senderId = req.user!.userId;
      const { senderId, recipientId, content } = req.body;

      const message = await this.chatService.sendMessage(
        senderId,
        recipientId,
        content
      );

      if (this.io) {
        this.io.to(recipientId).emit('receiveMessage', message);
      }

      res.status(201).json({ success: true, message });
    } catch (error: any) {
      res.status(400).json({ success: false, error: error.message });
    }
  }

  private async getConversations(req: Request, res: Response) {
    try {
      const userId = req.query.userId as string;
      const conversations = await this.chatService.getConversations(userId);
      res.json({ success: true, conversations });
    } catch (error: any) {
      res.status(500).json({ success: false, error: error.message });
    }
  }

  private async getMessages(req: Request, res: Response) {
    try {
      const userId = req.query.userId as string;
      const recipientId = req.params.recipientId;

      const messages = await this.chatService.getMessages(userId, recipientId);
      res.json({ success: true, messages });
    } catch (error: any) {
      res.status(500).json({ success: false, error: error.message });
    }
  }

  private async markAsRead(req: Request, res: Response) {
    try {
      const userId = req.query.userId as string;
      const recipientId = req.params.recipientId;
      await this.chatService.markMessagesAsRead(userId, recipientId);
      res.json({ success: true });
    } catch (error: any) {
      res.status(500).json({ success: false, error: error.message });
    }
  }

  private async getChatList(req: Request, res: Response) {
    try {
      const userId = req.query.userId as string;

      const conversations = await this.chatService.getChatList(userId);
      res.json({ success: true, conversations });
    } catch (error: any) {
      res.status(500).json({ success: false, error: error.message });
    }
  }

  private async getOrCreateRoom(req: Request, res: Response) {
    try {
      const senderId = req.query.senderId as string;
      const recipientId = req.query.recipientId as string;

      if (!senderId || !recipientId) {
        return res
          .status(400)
          .json({ success: false, message: 'Missing senderId or recipientId' });
      }

      const roomId = await this.chatService.getOrCreateRoom(
        senderId,
        recipientId
      );
      res.status(200).json({ success: true, roomId });
    } catch (error: any) {
      res.status(500).json({ success: false, error: error.message });
    }
  }
}
