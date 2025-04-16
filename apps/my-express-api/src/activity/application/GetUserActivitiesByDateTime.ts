import { injectable, inject } from "inversify";
import UserModel from "../../auth/infrastructure/models/User";
import ActivityModel from "../infrastructure/models/Activity";
import { Config } from "../../config/config";

@injectable()
export class GetUserActivitiesByDateTime {
  constructor(
    @inject(Config) private config: Config
  ) {}

  async execute(
    userId: string,
    date: string, // Format: "DD-MM-YYYY"
    time: string  // Format: "HH:MM AM/PM"
  ) {
    try {
      // Validate date and time formats
      if (!/^\d{2}-\d{2}-\d{4}$/.test(date)) {
        throw new Error("Invalid date format. Use DD-MM-YYYY");
      }
      if (!/^\d{2}:\d{2} [AP]M$/.test(time)) {
        throw new Error("Invalid time format. Use HH:MM AM/PM");
      }

      // Get complete user details
      const user = await UserModel.findOne({ userId }).lean();
      if (!user) {
        throw new Error("User not found");
      }

      // Get complete activity details for the specified date and time
      const activities = await ActivityModel.find({
        userId,
        Date: date,
        Time: time
      }).lean();

      // Combine user and activity details
      const result = activities.map(activity => ({
        user: {
          userId: user.userId,
          name: user.name,
          email: user.email,
          profileImage: user.profileImage,
          // Add other user fields you need
        },
        activity: {
          id: activity._id,
          Activity: activity.Activity,
          PlayerLevel: activity.PlayerLevel,
          Date: activity.Date,
          Time: activity.Time,
          notes: activity.notes,
          videoUrl: activity.videoUrl,
          createdAt: activity.createdAt
          // Add other activity fields you need
        }
      }));

      return {
        success: true,
        count: result.length,
        data: result
      };
    } catch (error: any) {
      console.error("GetUserActivitiesByDateTime error:", error);
      throw new Error(error.message || "Failed to fetch activities");
    }
  }
}