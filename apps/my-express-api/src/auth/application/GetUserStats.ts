// 1. Create new use case
// src/user/application/GetUserStats.ts
import { injectable } from "inversify";
import UserModel from "../infrastructure/models/User";
import ActivityModel from "../../activity/infrastructure/models/Activity";

@injectable()
export class GetUserStats {
  async execute(requesterId: string, activityId: string) {
    const [user, activityCount, activityDetails] = await Promise.all([
      UserModel.findOne({ userId: requesterId })
        .select('name profileImage placeName countryName state scheduledActivities')
        .lean(),
      ActivityModel.countDocuments({ userId: requesterId }),
      activityId ? ActivityModel.findById(activityId) : null
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
      opponents: user.scheduledActivities?.length || 0,
      totalActivities: activityCount,
      activityDetails: activityDetails ? {
        activity: activityDetails.Activity,
        playerLevel: activityDetails.PlayerLevel
      } : null
    };
  }
}