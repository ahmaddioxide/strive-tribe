// src/auth/application/getUserActivities.ts
import { injectable } from "inversify";
import ActivityModel from "../../activity/infrastructure/models/Activity";

@injectable()
export class GetUserActivities {
  async execute(userId: string) {
    try {
      const activities = await ActivityModel.find({ userId }).sort({ createdAt: -1 });
      return activities;
    } catch (error: any) {
      console.error("Failed to fetch activities:", error.message);
      throw new Error("Failed to fetch user activities");
    }
  }
}