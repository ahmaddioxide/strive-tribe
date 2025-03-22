import { Router, Request, Response } from 'express';
import { inject, injectable } from "inversify";
import { Identifier } from "../../../constants/identifiers";
import { CreateUser } from "../../application/register";
import IController from "./IController";

@injectable()
export default class AuthController implements IController {
  public path = '/user';
  public router: Router = Router();
  public createUser: CreateUser ;

  private _authMiddleWare: any;


  constructor( @inject(Identifier.createUser) createUser: CreateUser) {
    this.intializeRoutes();
    this.createUser = createUser;
  }

  private intializeRoutes() {
   this.router.post(this.path, this._authMiddleWare.auth, this.create);
  }

  private async create(request:Request, respone: Response){
    let response = await this.createUser.execute();
    respone.status(200).send({
      message: 'Temporary success message'
    });
  }
  

}
