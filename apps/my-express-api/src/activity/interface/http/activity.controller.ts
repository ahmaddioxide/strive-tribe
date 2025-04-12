// src/activity/interface/http/activity.controller.ts
import { Router, Request, Response } from "express";
import { inject, injectable } from "inversify";
import { AddActivity } from "../../application/AddActivity";
import { validateAddActivity } from "../middleware/validation";
import IController from "../../../auth/interface/http/IController";

@injectable()
export class ActivityController implements IController {
  public router: Router = Router();
  public path = "/activities";

  constructor(
    @inject(AddActivity) private addActivity: AddActivity
  ) {
    this.initializeRoutes();
  }

  private initializeRoutes() {
    this.router.post(
      `${this.path}`,
      validateAddActivity,
      this.addActivityHandler.bind(this)
    );
  }

  private addActivityHandler = async (req: Request, res: Response) => {
    try {
      const { video, ...activityData } = req.body;
      const response = await this.addActivity.execute(
        {
          userId: activityData.user_id,
          selectActivity: activityData.selectActivity,
          selectPlayerLevel: activityData.selectPlayerLevel,
          selectDate: activityData.selectDate,
          selectTime: activityData.selectTime,
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
}