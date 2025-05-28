//src/auth/interface/http/IController.ts
import * as express from "express";

export default interface IController {
  router: express.Router;
}
