// src/activity/interface/http/activity.controller.ts
import { Router, Request, Response } from "express";
import { inject, injectable } from "inversify";
import { AddActivity } from "../../application/AddActivity";
import { FindNearbyActivities } from "../../application/FindNearbyActivities";
import { GetUserActivitiesByDateTime } from "../../application/GetUserActivitiesByDateTime";
import { validateAddActivity, validateFindNearbyActivities, validateGetActivitiesByDateTime } from "../middleware/validation";
import IController from "../../../auth/interface/http/IController";

@injectable()
export class ActivityController implements IController {
  public router: Router = Router();
  public path = "/activities";

  constructor(
    @inject(AddActivity) private addActivity: AddActivity,
    @inject(FindNearbyActivities) private findNearbyActivities: FindNearbyActivities,
    @inject(GetUserActivitiesByDateTime) private getUserActivities: GetUserActivitiesByDateTime
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
      `${this.path}/activity-by-date-time`,
      validateGetActivitiesByDateTime,
      this.getActivitiesByDateTimeHandler.bind(this)
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
        activityName as string | undefined,
        playerLevel as string | undefined
      );

      res.status(200).json(response);
    } catch (error: any) {
      res.status(500).json({
        success: false,
        error: error.message || "Failed to find nearby activities"
      });
    }
  };


  private getActivitiesByDateTimeHandler = async (req: Request, res: Response) => {
    try {
      const { user_id, date, time } = req.query;
      
      const response = await this.getUserActivities.execute(
        user_id as string,
        date as string,
        time as string
      );

      res.status(200).json(response);
    } catch (error: any) {
      res.status(500).json({
        success: false,
        error: error.message || "Failed to fetch activities"
      });
    }
  };
}