import { injectable, inject } from "inversify";
import UserModel from "../../auth/infrastructure/models/User";
import ActivityModel from "../infrastructure/models/Activity";
import { Config } from "../../config/config";

@injectable()
export class FindNearbyActivities {
  constructor(
    @inject(Config) private config: Config
  ) {}

  private async getNearbyUserIds(userId: string): Promise<string[]> {
    const user = await UserModel.findOne({ userId });
    if (!user) throw new Error("User not found");
    if (!user.latitude || !user.longitude) throw new Error("User location missing");

    const earthRadius = 6371; // Earth's radius in km
    const radius = 2.5; // 2.5km radius
    const userLat = parseFloat(user.latitude);
    const userLng = parseFloat(user.longitude);

    const nearbyUsers = await UserModel.find({
      userId: { $ne: userId },
      latitude: { $exists: true },
      longitude: { $exists: true },
      $and: [
        {
          latitude: {
            $gte: userLat - (radius / earthRadius) * (180 / Math.PI),
            $lte: userLat + (radius / earthRadius) * (180 / Math.PI)
          }
        },
        {
          longitude: {
            $gte: userLng - (radius / earthRadius) * (180 / Math.PI) / Math.cos(userLat * Math.PI / 180),
            $lte: userLng + (radius / earthRadius) * (180 / Math.PI) / Math.cos(userLat * Math.PI / 180)
          }
        }
      ]
    }).select('userId').lean();

    return nearbyUsers.map(u => u.userId);
  }

  async execute(
    userId: string,
    activityName?: string,
    playerLevel?: string
  ) {
    try {
      const nearbyUserIds = await this.getNearbyUserIds(userId);

      const query: any = { 
        userId: { $in: nearbyUserIds } 
      };

      if (activityName) {
        query.selectActivity = activityName;
      }
      if (playerLevel) {
        query.selectPlayerLevel = playerLevel;
      }

      const activities = await ActivityModel.find(query)
        .select('userId selectActivity selectPlayerLevel selectDate selectTime')
        .sort({ createdAt: -1 })
        .lean();

      return {
        success: true,
        count: activities.length,
        activities: activities.map(activity => ({
          name: activity.selectActivity,
          playerLevel: activity.selectPlayerLevel,
          date: activity.selectDate,
          time: activity.selectTime,
          userId: activity.userId
        }))
      };
    } catch (error: any) {
      console.error("FindNearbyActivities error:", error);
      throw new Error(error.message || "Failed to find nearby activities");
    }
  }
}