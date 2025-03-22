/**
 * This is not a production server yet!
 * This is only a minimal backend to get started.
 */
import dotenv from 'dotenv';
import { IDatabase } from './database/IDatabase';
import  container  from "./config/installer";
import { Identifier } from "./constants/identifiers";
import Server from "./auth/interface/http/server";
import IController from "./auth/interface/http/IController";

dotenv.config(); // Load environment variables from a .env file

let config = container.get<any>(Identifier.config);

let dbDriver:IDatabase = container.get<IDatabase>(Identifier.databaseDriver);
dbDriver.connect().then((data) => {
  const server = new Server(
    [
      container.get<IController>(Identifier.authController),
  
    ],
    config.port,
  );
  console.log('Database Connected');
}).catch((error:Error) => {
  console.error(error);
});