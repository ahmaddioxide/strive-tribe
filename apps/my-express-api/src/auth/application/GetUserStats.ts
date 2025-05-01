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

    // Calculate activities per month
    const monthlyActivities = new Map<string, number>();
    Array.isArray(user.scheduledActivities) && user.scheduledActivities.forEach(activity => {
      if (typeof activity.date === 'string') {
        try {
          const [day, month, year] = activity.date.split('-');
          const monthYear = `${month}-${year}`;
          monthlyActivities.set(monthYear, (monthlyActivities.get(monthYear) || 0) + 1);
        } catch {
          // Ignore invalid dates
        }
      }
    });

    // Convert map to sorted array
    const activitiesPerMonth = Array.from(monthlyActivities)
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([monthYear, count]) => ({
        count
      }));

    // Calculate different opponents
    const opponentIds = new Set<string>();
    Array.isArray(user.scheduledActivities) && user.scheduledActivities.forEach(activity => {
      if (activity.userId) opponentIds.add(activity.userId);
    });

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
      differentOpponents: opponentIds.size,
      activitiesPerMonth,
      totalActivities: activityCount,
      activityDetails: activityDetails ? {
        activity: activityDetails.Activity,
        playerLevel: activityDetails.PlayerLevel
      } : null
    };
  }
}