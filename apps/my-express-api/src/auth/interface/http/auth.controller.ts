import { Router, Request, Response, NextFunction } from "express";
import { inject, injectable } from "inversify";
import { RegisterUser } from "../../application/register";
import { LoginUser } from "../../application/login";
import IController from "./IController";
import { validateRegister, validateLogin } from "../middleware/validation";

@injectable()
export default class AuthController implements IController {
  public path = "/auth";
  public router: Router = Router();
  private registerUser: RegisterUser;
  private loginUser: LoginUser;

  constructor(
    @inject(RegisterUser) registerUser: RegisterUser,
    @inject(LoginUser) loginUser: LoginUser,
  ) {
    this.registerUser = registerUser;
    this.loginUser = loginUser;
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
  }

  private register = async (req: Request, res: Response) => {
    try {
      const { profile_image, ...userData } = req.body;
      
      // Base64 validation
      /*if(profile_image && !this.isValidBase64Image(profile_image)) {
        return res.status(400).json({
          success: false,
          error: "Invalid image format. Use base64 encoded image with data:image/ prefix"
        });
      }*/

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

  private isValidBase64Image(base64String: string): boolean {
    return base64String.startsWith('data:image/');
  }
}