//src/auth/interface/http/auth.controller.ts
import { Router, Request, Response, NextFunction } from "express";
import { inject, injectable } from "inversify";
import { RegisterUser } from "../../application/register";
import { LoginUser } from "../../application/login";
import { UpdateUser } from "../../application/update";
import { CheckUser } from "../../application/check";
import { GetUser } from "../../application/getUser";
import { GetUserActivities } from "../../application/getUserActivities";
import { GetUserStats } from "../../application/GetUserStats";
import { FindNearbyPlayers } from "../../application/FindNearbyPlayers";
import { GetCommonActivities } from "../../application/GetCommonActivities";
import { GetTerms } from "../../application/getTerms";
import { ReportProblem } from "../../application/reportProblem";
import IController from "./IController";
import { validateRegister, validateLogin, validateUpdate, validateCheckUser, validateGetUser, validateGetUserById, validateNearPlayerByUserById, validateCommonActivities, validateGetActivities, validateReportProblem } from "../middleware/validation";

@injectable()
export default class AuthController implements IController {
  public path = "/auth";
  public router: Router = Router();
  private registerUser: RegisterUser;
  private loginUser: LoginUser;
  private updateUser: UpdateUser;
  private checkUser: CheckUser;
  private getUser: GetUser;
  private getUserStats: GetUserStats;
  private findNearbyPlayers: FindNearbyPlayers;
  private getCommonActivities: GetCommonActivities;
  private getUserActivities: GetUserActivities;
  private getTerms: GetTerms;
  private reportProblem: ReportProblem;

  constructor(
    @inject(RegisterUser) registerUser: RegisterUser,
    @inject(LoginUser) loginUser: LoginUser,
    @inject(UpdateUser) updateUser: UpdateUser,
    @inject(CheckUser) checkUser: CheckUser,
    @inject(GetUser) getUser: GetUser,
    @inject(GetUserStats) getUserStats: GetUserStats,
    @inject(FindNearbyPlayers) findNearbyPlayers: FindNearbyPlayers,
    @inject(GetCommonActivities) getCommonActivities: GetCommonActivities,
    @inject(GetUserActivities) getUserActivities: GetUserActivities,
    @inject(GetTerms) getTerms: GetTerms,
    @inject(ReportProblem) reportProblem: ReportProblem
  ) {
    this.registerUser = registerUser;
    this.loginUser = loginUser;
    this.updateUser = updateUser;
    this.checkUser = checkUser;
    this.getUser = getUser;
    this.getUserStats = getUserStats;
    this.findNearbyPlayers = findNearbyPlayers;
    this.getCommonActivities = getCommonActivities;
    this.getUserActivities = getUserActivities;
    this.getTerms = getTerms;
    this.reportProblem = reportProblem;
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
    this.router.get(
      `${this.path}/user-stats`,
      validateGetUserById,
      this.handleGetStats.bind(this)
    );
    this.router.get(
      `${this.path}/nearby-players/:userId`,
      validateNearPlayerByUserById,
      this.handleNearbyPlayers.bind(this)
    );
    this.router.get(
      `${this.path}/common_activities`,
      validateCommonActivities,
      this.handleCommonActivities.bind(this)
    );
    this.router.get(
      `${this.path}/my_activities`,
      validateGetActivities,
      this.handleGetActivities.bind(this)
    );
    this.router.get(
      `${this.path}/terms-and-conditions`,
      this.handleGetTerms.bind(this)
    );
    this.router.post(
      `${this.path}/report-problem`,
      validateReportProblem,
      this.handleReportProblem.bind(this)
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
      const statusCode = error.message.includes('Firebase') ? 401 : 500;
      const errorMessage = error.message.replace('Firebase verification failed: ', '');

      res.status(statusCode).json({ 
        success: false,
        error: errorMessage || "Registration failed",
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
      const { user_id } = req.query;
      const exists = await this.checkUser.execute(user_id as string);
      
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
      const  userId  = req.query.userId as string;
      const userData = await this.getUser.execute(userId);
      
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

  private async handleGetStats(req: Request, res: Response) {
    try {
      const result = await this.getUserStats.execute(req.query.requesterId as string, req.query.activityId as string);
      res.status(200).json({
        success: true,
        data: result
      });
    } catch (error: any) {
      const statusCode = error.message.includes('not found') ? 404 : 500;
      res.status(statusCode).json({
        success: false,
        error: error.message
      });
    }
  }

  private async handleNearbyPlayers(req: Request, res: Response) {
    try {
      const activities = req.query.activity 
        ? (req.query.activity as string).split(',').map(a => a.trim())
        : [];
  
      const result = await this.findNearbyPlayers.execute(
        req.params.userId,
        activities
      );
      
      res.status(200).json(result);
    } catch (error: any) {
      const statusCode = error.message.includes("not found") ? 404 : 500;
      res.status(statusCode).json({
        success: false,
        error: error.message
      });
    }
  }

  private async handleCommonActivities(req: Request, res: Response) {
    try {
      const { reqFrom, reqTo } = req.query;

      const result = await this.getCommonActivities.execute(reqFrom as string, reqTo as string);

      res.status(200).json({
        success: true,
        commonActivities: result,
      });
    } catch (error: any) {
      res.status(500).json({
        success: false,
        error: error.message || "Failed to fetch common activities",
      });
    }
  }

  private async handleGetActivities(req: Request, res: Response) {
    try {
      const userId = req.query.userId as string;
      const activities = await this.getUserActivities.execute(userId);

      res.status(200).json({
        success: true,
        activities
      });
    } catch (error: any) {
      res.status(500).json({
        success: false,
        error: error.message || "Failed to fetch activities"
      });
    }
  }
  private async handleGetTerms(req: Request, res: Response) {
    try {
      const terms = await this.getTerms.execute();
      
      res.status(200).json({
        success: true,
        terms
      });
    } catch (error: any) {
      res.status(500).json({
        success: false,
        error: error.message || "Failed to fetch terms and conditions"
      });
    }
  }

  private async handleReportProblem(req: Request, res: Response) {
    try {
      const { name, email, description } = req.body;
      
      const report = await this.reportProblem.execute(
        name,
        email,
        description
      );
      
      res.status(201).json({
        success: true,
        message: "Problem report submitted successfully",
        report
      });
    } catch (error: any) {
      res.status(500).json({
        success: false,
        error: error.message || "Failed to submit problem report"
      });
    }
  }
}