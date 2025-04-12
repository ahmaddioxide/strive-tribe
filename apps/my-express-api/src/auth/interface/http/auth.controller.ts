import { Router, Request, Response, NextFunction } from "express";
import { inject, injectable } from "inversify";
import { RegisterUser } from "../../application/register";
import { LoginUser } from "../../application/login";
import { UpdateUser } from "../../application/update";
import { CheckUser } from "../../application/check";
import { GetUser } from "../../application/getUser";
import IController from "./IController";
import { validateRegister, validateLogin, validateUpdate, validateCheckUser, validateGetUser } from "../middleware/validation";

@injectable()
export default class AuthController implements IController {
  public path = "/auth";
  public router: Router = Router();
  private registerUser: RegisterUser;
  private loginUser: LoginUser;
  private updateUser: UpdateUser;
  private checkUser: CheckUser;
  private getUser: GetUser;

  constructor(
    @inject(RegisterUser) registerUser: RegisterUser,
    @inject(LoginUser) loginUser: LoginUser,
    @inject(UpdateUser) updateUser: UpdateUser,
    @inject(CheckUser) checkUser: CheckUser,
    @inject(GetUser) getUser: GetUser
  ) {
    this.registerUser = registerUser;
    this.loginUser = loginUser;
    this.updateUser = updateUser;
    this.checkUser = checkUser;
    this.getUser = getUser;
    this.initializeRoutes();
  }

  private initializeRoutes() {
    this.router.post(
      `${this.path}/register`,
      validateRegister,
      this.register.bind(this)
    );
    this.router.post(
      `${this.path}/login`, 
      validateLogin, 
      this.login.bind(this)
    );
    this.router.put(
      `${this.path}/update`,
      validateUpdate,
      this.update.bind(this)
    );
    this.router.get(
      `${this.path}/checkuser`,
      validateCheckUser,
      this.checkUserHandler.bind(this)
    );
    this.router.get(
      `${this.path}/getuser`,
      validateGetUser,
      this.getUserHandler.bind(this)
    );
  }

  private register = async (req: Request, res: Response) => {
    try {
      const { profile_image, ...userData } = req.body;
      
      // Base64 validation
      if(profile_image && !this.isValidBase64Image(profile_image)) {
        return res.status(400).json({
          success: false,
          error: "Invalid image format. Use base64 encoded image with data:image/ prefix"
        });
      }

      const response = await this.registerUser.execute(userData, profile_image);
      res.status(201).json(response);
    } catch (error: any) {
      res.status(500).json({ 
        success: false,
        error: error.message || "Registration failed",
        ...(process.env.NODE_ENV === 'development' && { stack: error.stack })
      });
    }
  };

  private login = async (req: Request, res: Response) => {
    try {
      const { user_id } = req.body;
  
      if (!user_id) {
        return res.status(400).json({ 
          success: false,
          error: "user_id is required" 
        });
      }
  
      const response = await this.loginUser.execute(user_id);
      res.status(200).json(response);
    } catch (error: any) {
      if (error.message === "User not registered") {
        res.status(404).json({ 
          success: false,
          message: "User not found in our system" 
        });
      } else {
        res.status(500).json({
          success: false,
          error: error.message || "Login failed"
        });
      }
    }
  };

  private update = async (req: Request, res: Response) => {
    try {
      const { user_id, profile_image, ...updateData } = req.body;
      
      const response = await this.updateUser.execute(
        user_id,
        updateData,
        profile_image
      );
      
      res.status(200).json(response);
    } catch (error: any) {
      res.status(500).json({ 
        success: false,
        error: error.message || "Update failed",
        ...(process.env.NODE_ENV === 'development' && { stack: error.stack })
      });
    }
  };

  private isValidBase64Image(base64String: string): boolean {
    return base64String.startsWith('data:image/');
  }

  private checkUserHandler = async (req: Request, res: Response) => {
    try {
      const { user_id } = req.body;
      const exists = await this.checkUser.execute(user_id);
      
      res.status(200).json({
        success: true,
        exists
      });
    } catch (error: any) {
      res.status(500).json({ 
        success: false,
        error: error.message || "Check user failed"
      });
    }
  };

  private getUserHandler = async (req: Request, res: Response) => {
    try {
      const { user_id } = req.body;
      const userData = await this.getUser.execute(user_id);
      
      res.status(200).json({
        success: true,
        user: userData
      });
    } catch (error: any) {
      if (error.message === "User not found") {
        res.status(404).json({
          success: false,
          error: "User not found"
        });
      } else {
        res.status(500).json({ 
          success: false,
          error: error.message || "Failed to fetch user data"
        });
      }
    }
  }
}