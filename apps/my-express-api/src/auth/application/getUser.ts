// src/auth/application/getUser.ts
import { injectable } from "inversify";
import UserModel from "../infrastructure/models/User";
import ActivityModel from "../../activity/infrastructure/models/Activity";

@injectable()
export class GetUser {
  async execute(userId: string) {
    // Get user data with scheduled activities
    const [user, totalActivities] = await Promise.all([
      UserModel.findOne({ userId })
        .select('id name email profileImage placeName state countryName scheduledActivities gamesPlayed')
        .lean(),
      ActivityModel.countDocuments({ userId })
    ]);

    if (!user) {
      throw new Error("User not found");
    }

    // Parse scheduledActivities
    const scheduledActivities = Array.isArray(user.scheduledActivities)
      ? user.scheduledActivities
      : JSON.parse(user.scheduledActivities || '[]');

    // Calculate gamesPlayed
    const gamesPlayed = scheduledActivities.length;

    // Calculate different opponents
    const opponentIds = new Set<string>();
    scheduledActivities.forEach(activity => {
      if (activity.userId) opponentIds.add(activity.userId);
    });

    // Calculate activities per month
    const monthlyCounts = new Map<string, number>();
    scheduledActivities.forEach(activity => {
      try {
        const [day, month, year] = activity.date.split('-');
        const monthYear = `${month}-${year}`;
        monthlyCounts.set(monthYear, (monthlyCounts.get(monthYear) || 0) + 1);
      } catch {
        // Ignore invalid dates
      }
    });

    // Only keep counts (remove monthYear)
    const activitiesPerMonth = Array.from(monthlyCounts.values()).map(count => ({ count }));

    // Exclude _id and scheduledActivities from final response
    const { scheduledActivities: _, _id, ...restUser } = user;

    const userWithStats = {
      ...restUser,
      id: _id?.toString() || '',
      totalActivities,
      gamesPlayed,
      differentOpponents: opponentIds.size,
      activitiesPerMonth
    };

    return userWithStats;
  }
}
