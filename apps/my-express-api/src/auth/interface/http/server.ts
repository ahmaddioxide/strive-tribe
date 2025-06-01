// src/auth/interface/http/server.ts
import express from 'express';
import * as http from 'http';
import { Server as SocketIOServer, Socket } from 'socket.io';
import helmet from 'helmet';
import cors from 'cors';
import { injectable } from 'inversify';
import IController from './IController';
import { errorHandler } from '../middleware/errorHandler';
import UserModel from '../../infrastructure/models/User';
import jwt from 'jsonwebtoken';
import { Config } from '../../../config/config';
import { ChatService } from '../../../chat/application/ChatService';

@injectable()
class Server {
  public app: express.Application;
  public server: http.Server;
  public io: SocketIOServer;
  public port: number;

  constructor(
    controllers: IController[],
    port: number,
    private config: Config,
    private chatService: ChatService
  ) {
    this.app = express();
    this.port = port;
    this.server = http.createServer(this.app);

    this.io = new SocketIOServer(this.server, {
      cors: {
        origin: '*',
        methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
        allowedHeaders: ['Authorization', 'Content-Type'],
        credentials: true,
      },
      transports: ['websocket', 'polling'],
      allowEIO3: true,
      pingInterval: 10000,
      pingTimeout: 5000,
      cookie: false,
      serveClient: false,
    });

    this.initializeMiddlewares();
    this.initializeControllers(controllers);
    this.initializeSocket();
  }

  private initializeMiddlewares() {
    this.app.use(cors());
    this.app.use(helmet());
    this.app.use(express.json({ limit: '200mb' }));
    this.app.use(express.urlencoded({ extended: true, limit: '200mb' }));
  }

  private initializeControllers(controllers: IController[]) {
    controllers.forEach((controller: IController) => {
      this.app.use('/api', controller.router);
    });

    this.app.use(errorHandler);
  }

  private initializeSocket() {
    this.io.on('connection_error', (err) => {
      console.error('Socket connection error:', err.message);
    });

    this.io.use(async (socket: Socket, next) => {
      const token =
        socket.handshake.auth?.token ||
        socket.handshake.query?.token ||
        (socket.handshake.headers.authorization?.startsWith('Bearer ')
          ? socket.handshake.headers.authorization.split(' ')[1]
          : null);

      if (!token) {
        console.log('No token provided');
        return next(new Error('Authentication required'));
      }

      try {
        const decoded = jwt.verify(token, this.config.jwt_token_secret) as {
          id: string;
        };
        const user = await UserModel.findById(decoded.id);

        if (!user) {
          console.log(`User not found for ID: ${decoded.id}`);
          return next(new Error('User not found'));
        }

        socket.data.userId = user.userId;
        console.log(`Authenticated user: ${user.userId}`);
        next();
      } catch (error: any) {
        console.error('Token verification error:', error.message);
        next(new Error('Invalid token'));
      }
    });

    this.io.on('connection', (socket: Socket) => {
      console.log(`New connection: ${socket.id} (User: ${socket.data.userId})`);

      socket.join(socket.data.userId);

      socket.on('ping', (callback) => {
        console.log(`Ping from ${socket.data.userId}`);
        callback('pong');
      });

      // Updated sendMessage with validation & detailed logging
      socket.on('sendMessage', async ({ recipientId, content }) => {
        console.log('Received sendMessage payload:', { recipientId, content });

        if (!recipientId || !content) {
          console.log('recipientId or content missing:', { recipientId, content });
          return socket.emit('error', {
            event: 'sendMessage',
            message: 'recipientId or content missing',
          });
        }

        try {
          console.log(`Message from ${socket.data.userId} to ${recipientId}: ${content}`);

          const message = await this.chatService.sendMessage(
            socket.data.userId,
            recipientId,
            content
          );
          const chatList1 = await this.chatService.getChatList(socket.data.userId);
          const chatList2 = await this.chatService.getChatList(recipientId);

          // Emit to recipient and sender
          this.io.to(recipientId).emit('receiveMessage', message);
          socket.emit('receiveMessage', message);
          // this.io.to(recipientId).emit('chatRooms', {success: true, rooms: chatList2});
          // /*socket.emit('chatRooms', {
          //     success: true,
          //     rooms: chatList1,
          //   });
          // Also emit `newMessage` to recipient for new chat alert
          this.io.to(recipientId).emit('newMessage', message);
          // const chatList = await this.chatService.getChatList(socket.data.userId);


          this.io.to(socket.data.userId).emit('chatRooms', {success: true, rooms: chatList1});
          this.io.to(recipientId).emit('chatRooms', {success: true, rooms: chatList2});
          // socket.emit('chatRooms', {
          //   success: true,
          //   rooms: chatList,
          // });
        } catch (error: any) {
          console.error('Message send error:', error.message);
          socket.emit('error', {
            event: 'sendMessage',
            message: error.message,
          });
        }
      });


      socket.on('getAllRoom', async () => {
        try {
          const chatList = await this.chatService.getChatList(socket.data.userId);

          if (chatList.length === 0) {
            socket.emit('chatRooms', {
              success: true,
              rooms: [],
              message: 'No chat rooms found.',
            });
          } else {
            socket.emit('chatRooms', {
              success: true,
              rooms: chatList,
            });
          }
        } catch (err: any) {
          console.error('getAllRoom error:', err.message);
          socket.emit('error', {
            event: 'getAllRoom',
            message: err.message || 'Could not fetch chat rooms',
          });
        }
      });
      // Fetch chat history between users
      socket.on('getAllChat', async (data: any) => {
        try {
          if (!data || typeof data !== 'object') {
            throw new Error('Invalid request format');
          }

          const { recipientId } = data;

          if (!recipientId) {
            socket.emit('error', {
              event: 'getAllChat',
              message: 'recipientId is required',
            });
            return;
          }

          const messages = await this.chatService.getMessages(
            socket.data.userId,
            recipientId
          );

          socket.emit('historyMessage', {
            success: true,
            messages,
          });
        } catch (error: any) {
          console.error('GetAllChat error:', error.message);
          socket.emit('error', {
            event: 'getAllChat',
            message: error.message || 'Unknown error',
          });
        }
      });

      socket.on('markAsRead', async (data: any) => {
        try {
          if (!data || typeof data !== 'object') {
            throw new Error('Invalid request format');
          }

          const { recipientId } = data;

          if (!recipientId) {
            socket.emit('error', {
              event: 'markAsRead',
              message: 'recipientId is required',
            });
            return;
          }

          await this.chatService.markMessagesAsRead(
            socket.data.userId,
            recipientId
          );

          socket.emit('markAsReadSuccess', {
            success: true,
            message: 'Messages marked as read',
          });

          // // Optionally, notify recipient
          // this.io.to(recipientId).emit('messagesReadBy', {
          //   from: socket.data.userId,
          // });

        } catch (error: any) {
          console.error('markAsRead error:', error.message);
          socket.emit('error', {
            event: 'markAsRead',
            message: error.message || 'Failed to mark messages as read',
          });
        }
      });



      socket.on('disconnect', (reason) => {
        console.log(`Disconnected: ${socket.id} - ${reason}`);
      });
    });
  }

  public listen() {
    this.server.listen(this.port, () => {
      console.log(`Server listening on port ${this.port}`);
      console.log(`Socket.IO endpoint: ws://localhost:${this.port}`);
    });
  }
}

export default Server;
