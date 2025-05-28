// src/auth/interface/http/server.ts
import express from "express";
import * as http from "http";
import { Server as SocketIOServer } from "socket.io";
import helmet from "helmet";
import cors from "cors";
import { injectable } from "inversify";
import IController from "./IController";
import { errorHandler } from "../middleware/errorHandler";
import UserModel from "../../infrastructure/models/User";
import jwt from "jsonwebtoken";
import { Config } from "../../../config/config";
import {ChatService} from "../../../chat/application/ChatService"; // Make sure path is correct

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
        origin: "*",
      },
    });

    this.initializeMiddlewares();
    this.initializeControllers(controllers);
    this.initializeSocket();
  }

  private initializeMiddlewares() {
    this.app.use(cors());
    this.app.use(helmet());
    this.app.use(express.json({ limit: "200mb" }));
    this.app.use(express.urlencoded({ extended: true, limit: "200mb" }));
  }

  private initializeControllers(controllers: IController[]) {
    controllers.forEach((controller: IController) => {
      this.app.use("/api", controller.router);
    });

    this.app.use(errorHandler);
  }

  private initializeSocket() {
    this.io.use(async (socket, next) => {
      const token = socket.handshake.auth.token;
      if (!token) return next(new Error("Authentication required"));

      try {
        const decoded = jwt.verify(token, this.config.jwt_token_secret) as { id: string };
        const user = await UserModel.findById(decoded.id);
        if (!user) return next(new Error("User not found"));
        socket.data.userId = user.userId;
        next();
      } catch (error) {
        next(new Error("Invalid token"));
      }
    });

    this.io.on("connection", (socket) => {
      socket.join(socket.data.userId);

      socket.on("sendMessage", async ({ recipientId, content }) => {
        try {
          const message = await this.chatService.sendMessage(
            socket.data.userId,
            recipientId,
            content
          );
          this.io.to(recipientId).emit("receiveMessage", message);
        } catch (error: any) {
          socket.emit("error", { message: error.message });
        }
      });
    });
  }

  public listen() {
    this.server.listen(this.port, () => {
      console.log(`Server listening on port ${this.port}`);
    });
  }
}

export default Server;
