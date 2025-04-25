import { injectable } from "inversify";
import NotificationModel from "../infrastructure/models/Notification";
import Participation from "../infrastructure/models/Participation";

@injectable()
export class GetUserNotifications {
  async execute(userId: string) {
    const currentDate = new Date();
    
    // Fetch only notifications with 'pending' status
    const notifications = await NotificationModel.find({
      userId,
      status: 'pending' // only pending status
    }).lean();

    const enrichedNotifications = await Promise.all(
      notifications.map(async (notification) => {
        let participationId = null;

        if (notification.requesterId) {
          const participation = await Participation.findOne({
            userId: notification.requesterId,
          }).lean();

          if (participation) {
            participationId = participation._id;
          }
        }

        // Check if the activity is in the future
        const activityDateTime = this.parseActivityDateTime(notification.activityDate, notification.activityTime);
        const includeNotification = activityDateTime > currentDate;

        return includeNotification
          ? { ...notification, participationId }
          : null;
      })
    );

    return enrichedNotifications.filter(n => n !== null);
  }

  private parseActivityDateTime(date?: string, time?: string): Date {
    if (!date || !time) return new Date(0);

    const [day, month, year] = date.split('-').map(Number);
    const timeMatch = time.match(/(\d+):(\d+) (AM|PM)/i);

    if (!timeMatch) return new Date(0);

    let hours = parseInt(timeMatch[1]);
    const minutes = parseInt(timeMatch[2]);
    const period = timeMatch[3].toUpperCase();

    if (period === 'PM' && hours !== 12) hours += 12;
    if (period === 'AM' && hours === 12) hours = 0;

    return new Date(year, month - 1, day, hours, minutes);
  }
}
