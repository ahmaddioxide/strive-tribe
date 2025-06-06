// src/main.ts
import dotenv from "dotenv";
import { IDatabase } from "./database/IDatabase";
import container from "./config/installer";
import { Identifier } from "./constants/identifiers";
import Server from "./auth/interface/http/server";
import IController from "./auth/interface/http/IController";
import { Config } from "./config/config";
import { initializeFirebase } from "./config/firebase";
import {ChatService} from "./chat/application/ChatService";
import {ChatController} from "./chat/interface/http/chat.controller";

dotenv.config();

async function bootstrap() {
  try {
    const dbDriver = container.get<IDatabase>(Identifier.DatabaseDriver);
    const config = container.get<Config>(Identifier.Config);
    const authController = container.get<IController>(Identifier.AuthController);
    const activityController = container.get<IController>(Identifier.ActivityController);
    const chatController = container.get<ChatController>(Identifier.ChatController);
    const chatService = container.get<ChatService>(ChatService);

    initializeFirebase(config);

    await dbDriver.connect();

    const server = new Server(
      [authController, activityController, chatController],
      config.port,
      config,
      chatService
    );

    chatController.setIo(server.io); // Link Socket.IO instance

    server.listen();
  } catch (error) {
    console.error("Failed to start application:", error);
    process.exit(1);
  }
}

bootstrap();
