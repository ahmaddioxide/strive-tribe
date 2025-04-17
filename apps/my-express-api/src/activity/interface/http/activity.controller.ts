// src/activity/interface/http/activity.controller.ts
import { Router, Request, Response } from "express";
import { inject, injectable } from "inversify";
import { AddActivity } from "../../application/AddActivity";
import { FindNearbyActivities } from "../../application/FindNearbyActivities";
import { GetActivityDetails } from "../../application/GetUserActivitiesById";
import { validateAddActivity, validateFindNearbyActivities, validateActivityId } from "../middleware/validation";
import IController from "../../../auth/interface/http/IController";

@injectable()
export class ActivityController implements IController {
  public router: Router = Router();
  public path = "/activities";

  constructor(
    @inject(AddActivity) private addActivity: AddActivity,
    @inject(FindNearbyActivities) private findNearbyActivities: FindNearbyActivities,
    @inject(GetActivityDetails) private getActivityDetails: GetActivityDetails,
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
}