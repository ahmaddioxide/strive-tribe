// src/activity/interface/http/activity.controller.ts
import { Router, Request, Response } from "express";
import { inject, injectable } from "inversify";
import { AddActivity } from "../../application/AddActivity";
import { FindNearbyActivities } from "../../application/FindNearbyActivities";
import { GetActivityDetails } from "../../application/GetUserActivitiesById";
import { ParticipateActivity } from "../../application/ParticipateActivity";
import { UpdateParticipationStatus } from "../../application/UpdateParticipationStatus";
import { GetUserNotifications } from "../../application/GetNotifications";
import { GetScheduledActivities } from "../../application/GetScheduledActivities";
import { validateAddActivity, validateFindNearbyActivities, validateActivityId, validateJoinActivity, validateUpdateParticipationStatus, validateGetNotifications, validateGetScheduledActivities } from "../middleware/validation";
import IController from "../../../auth/interface/http/IController";

@injectable()
export class ActivityController implements IController {
  public router: Router = Router();
  public path = "/activities";

  constructor(
    @inject(AddActivity) private addActivity: AddActivity,
    @inject(FindNearbyActivities) private findNearbyActivities: FindNearbyActivities,
    @inject(GetActivityDetails) private getActivityDetails: GetActivityDetails,
    @inject(ParticipateActivity) private participateActivity: ParticipateActivity,
    @inject(UpdateParticipationStatus) private UpdateParticipationStatus: UpdateParticipationStatus,
    @inject(GetUserNotifications) private getUserNotification: GetUserNotifications,
    @inject(GetScheduledActivities) private getScheduledActivities: GetScheduledActivities
    
  ) {
    this.initializeRoutes();
  }

  private initializeRoutes() {
    this.router.post(
      `${this.path}/create-activity`,
      validateAddActivity,
      this.addActivityHandler.bind(this)
    );
    this.router.get(
      `${this.path}/nearby/:user_id`,
      validateFindNearbyActivities,
      this.findNearbyActivitiesHandler.bind(this)
    );
    this.router.get(
      `${this.path}/activity-by-id/:id`,
      validateActivityId,
      this.getActivityDetailsHandler.bind(this)
    );
    this.router.post(
      `${this.path}/join`,
      validateJoinActivity, // Use middleware here
      this.handleJoinActivity.bind(this)
    );
    this.router.put(
      `${this.path}/participation/:id`,
      validateUpdateParticipationStatus,
      this.handleUpdateParticipationStatus.bind(this)
    );
    this.router.get(
      `${this.path}/notifications/:userId`,
      validateGetNotifications,
      this.getUserNotifications.bind(this)
    );
    this.router.get(
      `${this.path}/scheduled/:userId`,
      validateGetScheduledActivities,
      this.handleScheduledActivities.bind(this)
    );

  }

  private addActivityHandler = async (req: Request, res: Response) => {
    try {
      const { video, ...activityData } = req.body;
      const response = await this.addActivity.execute(
        {
          userId: activityData.user_id,
          Activity: activityData.Activity,
          PlayerLevel: activityData.PlayerLevel,
          Date: activityData.Date,
          Time: activityData.Time,
          notes: activityData.notes
        },
        video
      );

      res.status(201).json(response);
    } catch (error: any) {
      res.status(500).json({
        success: false,
        error: error.message || "Failed to add activity"
      });
    }
  };

  private findNearbyActivitiesHandler = async (req: Request, res: Response) => {
    try {
      const { user_id } = req.params;
      const { activityName, playerLevel } = req.query;

      const response = await this.findNearbyActivities.execute(
        user_id,
        activityName as string | string[],
        playerLevel as string | string[]
      );
  
      res.status(200).json(response);
    } catch (error: any) {
      res.status(500).json({
        success: false,
        error: error.message || "Failed to find nearby activities"
      });
    }
  };


  private getActivityDetailsHandler = async (req: Request, res: Response) => {
    try {

      const response = await this.getActivityDetails.execute(req.params.id);
      res.status(200).json(response);
    } catch (error: any) {
      const statusCode = error.message.includes("not found") ? 404 : 500;
      res.status(statusCode).json({
        success: false,
        error: error.message || "Failed to fetch activity details"
      });
    }
  };

  private handleJoinActivity = async (req: Request, res: Response) => {
    try {
      const { activityId, userId } = req.query;
      // if (typeof userId !== "string" || typeof activityId !== "string") {
      //   return res.status(400).json({
      //     success: false,
      //     error: "Invalid activityId or userId. Both must be strings."
      //   });
      // }
      const result = await this.participateActivity.execute(activityId as string, userId as string);
      
      
      res.status(201).json(result);
    } catch (error: any) {
      res.status(error.message.includes("already") ? 409 : 500).json({
        success: false,
        error: error.message || "Failed to join activity"
      });
    }
  };

  private handleUpdateParticipationStatus = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;//
      const { status, notificationId } = req.body;
  
      const result = await this.UpdateParticipationStatus.execute(id, status, notificationId as string);
  
      res.json({
        success: true,
        participation: {
          id: result._id,
          status: result.status,
          activityId: result.activityId,
          userId: result.userId
        }
      });
    } catch (error: any) {
      res.status(500).json({
        success: false,
        error: error.message || "Failed to update participation status"
      });
    }
  };

  private async getUserNotifications(req: Request, res: Response) {
    try {
      const { userId } = req.params;
      const notifications = await this.getUserNotification.execute(userId);
      
      res.status(200).json({
        success: true,
        notifications
      });
    } catch (error: any) {
      res.status(500).json({
        success: false,
        error: error.message || "Failed to fetch notifications"
      });
    }
  }

  private async handleScheduledActivities(req: Request, res: Response) {
    try {
      const result = await this.getScheduledActivities.execute(req.params.userId);
      
      res.status(200).json({
        success: true,
        count: result.length,
        scheduledActivities: result
      });
      
    } catch (error: any) {
      const statusCode = error.message.includes('not found') ? 404 : 500;
      res.status(statusCode).json({
        success: false,
        error: error.message || "Failed to fetch scheduled activities"
      });
    }
  }
  
}