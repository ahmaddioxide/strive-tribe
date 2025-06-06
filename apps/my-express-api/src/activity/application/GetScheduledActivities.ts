import { injectable } from "inversify";
import UserModel from "../../auth/infrastructure/models/User";

@injectable()
export class GetScheduledActivities {
  async execute(userId: string, activityFilter?: string | string[], playerLevelFilter?: string | string[]) {
    const currentDate = new Date();
    
    // Get user with scheduled activities
    const user = await UserModel.findOne({ userId })
      .select('scheduledActivities')
      .lean();

    if (!user) throw new Error('User not found');

    const activities = Array.isArray(user.scheduledActivities) ? user.scheduledActivities : [];

    const activityArray = Array.isArray(activityFilter)
      ? activityFilter
      : activityFilter?.split(',') || [];

    const levelArray = Array.isArray(playerLevelFilter)
      ? playerLevelFilter
      : playerLevelFilter?.split(',') || [];

    return activities
      .filter(scheduled => 
        this.isFutureActivity(scheduled.date, scheduled.time, currentDate) &&
        (activityArray.length === 0 || activityArray.includes(scheduled.activity)) &&
        (levelArray.length === 0 || levelArray.includes(scheduled.playerLevel))
      ).map(scheduled => ({
        id: scheduled._id.toString(),
        activityId: scheduled.activityId,
        activity: scheduled.activity,
        activityCreatorName: scheduled.partnerName,
        playerLevel: scheduled.playerLevel,
        date: scheduled.date,
        time: scheduled.time,
        status: 'Upcoming'
      }));
  }

  private isFutureActivity(dateStr: string, timeStr: string, now: Date): boolean {
    const [day, month, year] = dateStr.split('-').map(Number);
    const timeMatch = timeStr.match(/(\d+):(\d+) (AM|PM)/i);
    
    if (!timeMatch) return false;
    
    let hours = parseInt(timeMatch[1]);
    const minutes = parseInt(timeMatch[2]);
    const period = timeMatch[3].toUpperCase();

    if (period === 'PM' && hours !== 12) hours += 12;
    if (period === 'AM' && hours === 12) hours = 0;

    const activityDate = new Date(year, month - 1, day, hours, minutes);
    return activityDate > now;
  }
}
