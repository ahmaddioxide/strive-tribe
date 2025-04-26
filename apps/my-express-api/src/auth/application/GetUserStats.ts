// 1. Create new use case
// src/user/application/GetUserStats.ts
import { injectable } from "inversify";
import UserModel from "../infrastructure/models/User";
import ActivityModel from "../../activity/infrastructure/models/Activity";

@injectable()
export class GetUserStats {
  async execute(userId: string) {
    const [user, activityCount] = await Promise.all([
      UserModel.findOne({ userId })
        .select('name profileImage placeName countryName state activities scheduledActivities')
        .lean(),
      ActivityModel.countDocuments({ userId })
    ]);

    if (!user) throw new Error('User not found');

    return {
      basicInfo: {
        name: user.name,
        profileImage: user.profileImage || '',
        location: {
          placeName: user.placeName || '',
          countryName: user.countryName || '',
          state: user.state || ''
        }
      },
      activities: {
        details: user.activities.map(activity => ({
          name: activity.name,
          expertiseLevel: activity.expertise_level
        }))
      },
      opponents: user.scheduledActivities?.length || 0,
      totalActivities: activityCount
    };
  }
}