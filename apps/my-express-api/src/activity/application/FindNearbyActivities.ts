import { injectable, inject } from "inversify";
import UserModel from "../../auth/infrastructure/models/User";
import ActivityModel from "../infrastructure/models/Activity";
import { Config } from "../../config/config";

@injectable()
export class FindNearbyActivities {
  constructor(
    @inject(Config) private config: Config
  ) {}

  private calculateDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
    const R = 6371;
    const φ1 = this.toRad(lat1);
    const φ2 = this.toRad(lat2);
    const Δφ = this.toRad(lat2 - lat1);
    const Δλ = this.toRad(lon2 - lon1);

    const a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
              Math.cos(φ1) * Math.cos(φ2) *
              Math.sin(Δλ/2) * Math.sin(Δλ/2);

    return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  }

  private toRad(degrees: number): number {
    return degrees * Math.PI / 180;
  }

  private async getNearbyUsers(userId: string): Promise<{userId: string, name: string}[]> {
    const user = await UserModel.findOne({ userId });
    if (!user) throw new Error("User not found");
    if (!user.latitude || !user.longitude) throw new Error("User location missing");

    const userLat = parseFloat(user.latitude);
    const userLng = parseFloat(user.longitude);

    const allUsers = await UserModel.find({
      userId: { $ne: userId },
      latitude: { $exists: true, $ne: null },
      longitude: { $exists: true, $ne: null }
    }).select('userId latitude longitude name').lean();

    const nearbyUsers: {userId: string, name: string}[] = [];

    for (const otherUser of allUsers) {
      try {
        const otherLat = parseFloat(otherUser.latitude);
        const otherLng = parseFloat(otherUser.longitude);
        const distance = this.calculateDistance(userLat, userLng, otherLat, otherLng);

        if (distance <= 5) {
          nearbyUsers.push({
            userId: otherUser.userId,
            name: otherUser.name
          });
        }
      } catch (error) {
        console.error(`Error processing user ${otherUser.userId}:`, error);
        continue;
      }
    }

    return nearbyUsers;
  }

  async execute(
    userId: string,
    activityNames?: string | string[],
    playerLevels?: string | string[]
  ) {
    try {
      const nearbyUsers = await this.getNearbyUsers(userId);
      const nearbyUserIds = nearbyUsers.map(u => u.userId);

      if (nearbyUserIds.length === 0) {
        return {
          success: true,
          count: 0,
          activities: []
        };
      }

      const query: any = { 
        userId: { $in: nearbyUserIds } 
      };

      // Process activity names
      if (activityNames) {
        const activitiesArray = Array.isArray(activityNames) 
          ? activityNames 
          : activityNames.split(',');
        
        if (activitiesArray.length > 0) {
          query.Activity = { $in: activitiesArray };
        }
      }

      // Process player levels
      if (playerLevels) {
        const levelsArray = Array.isArray(playerLevels)
          ? playerLevels
          : playerLevels.split(',');
        
        if (levelsArray.length > 0) {
          query.PlayerLevel = { $in: levelsArray };
        }
      }

      const activities = await ActivityModel.find(query)
        .select('userId Activity PlayerLevel Date Time')
        .sort({ createdAt: -1 })
        .lean();

      const userNameMap = new Map<string, string>();
      nearbyUsers.forEach(user => {
        userNameMap.set(user.userId, user.name);
      });

      const formattedActivities = activities.map(activity => ({
        userId: activity.userId,
        name: userNameMap.get(activity.userId) || 'Unknown',
        activity: activity.Activity,
        playerLevel: activity.PlayerLevel,
        date: activity.Date,
        time: activity.Time
      }));

      return {
        success: true,
        count: formattedActivities.length,
        activities: formattedActivities
      };
    } catch (error: any) {
      console.error("FindNearbyActivities error:", error);
      throw new Error(error.message || "Failed to find nearby activities");
    }
  }
}