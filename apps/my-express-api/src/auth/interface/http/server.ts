// src/auth/interface/http/server.ts
import express from "express";
import * as bodyParser from "body-parser";
import helmet from "helmet";
import { injectable } from "inversify";
import cors from "cors";
import IController from "./IController";
import { errorHandler } from "../middleware/errorHandler";

@injectable()
class Server {
  public app: express.Application;
  public port: number;

  constructor(controllers: IController[], port: number) {
    this.app = express();
    this.port = port;
    this.initializeMiddlewares();
    this.initializeControllers(controllers);
  }

  private initializeMiddlewares() {
    this.app.use(cors());
    this.app.use(helmet());
    this.app.use(bodyParser.json());
  }

  private initializeControllers(controllers: IController[]) {
    controllers.forEach((controller: IController) => {
      this.app.use("/api", controller.router);
    });

    this.app.use(errorHandler);
  }

  public listen() {
    this.app.listen(this.port, () => {
      console.log(`App listening on port ${this.port}`);
    });
  }
}

export default Server;