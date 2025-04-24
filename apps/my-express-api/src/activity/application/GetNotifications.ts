// src/notifications/application/GetUserNotifications.ts
import { injectable } from "inversify";
import NotificationModel from "../infrastructure/models/Notification";
import Participation from "../infrastructure/models/Participation";

@injectable()
export class GetUserNotifications {
  async execute(userId: string) {
    const currentDate = new Date();
    
    // Fetch notifications
    const notifications = await NotificationModel.find({ userId }).lean();

    // Prepare enhanced notifications
    const enrichedNotifications = await Promise.all(
      notifications.map(async (notification) => {
        // Default: no participationId
        let participationId = null;

        if (notification.requesterId) {
          const participation = await Participation.findOne({
            userId: notification.requesterId,
          }).lean();

          if (participation) {
            participationId = participation._id;
          }
        }

        // Filter logic
        const includeNotification = (
          notification.status !== 'pending' ||
          this.parseActivityDateTime(notification.activityDate, notification.activityTime) > currentDate
        );

        return includeNotification
          ? { ...notification, participationId }
          : null;
      })
    );

    // Remove nulls from filtered out notifications
    return enrichedNotifications.filter(n => n !== null);
  }

  private parseActivityDateTime(date?: string, time?: string): Date {
    if (!date || !time) return new Date(0); // Invalid date

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
