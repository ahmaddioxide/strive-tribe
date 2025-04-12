// src/main.ts
import dotenv from 'dotenv';
import { IDatabase } from './database/IDatabase';
import container from "./config/installer";
import { Identifier } from "./constants/identifiers";
import Server from "./auth/interface/http/server";
import IController from "./auth/interface/http/IController";
import { Config } from "./config/config";
import { initializeFirebase } from "./config/firebase";

dotenv.config();

async function bootstrap() {
  try {
    const dbDriver = container.get<IDatabase>(Identifier.databaseDriver);
    const config = container.get<Config>(Identifier.config);
    const authController = container.get<IController>(Identifier.authController);
    const activityController = container.get<IController>(Identifier.activityController);

    initializeFirebase(config);
    
    await dbDriver.connect();
    
    const server = new Server(
      [authController, activityController],
      config.port
    );
    
    server.listen();
  } catch (error) {
    console.error('Failed to start application:', error);
    process.exit(1);
  }
}

bootstrap();