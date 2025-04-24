// src/notifications/application/GetUserNotifications.ts
import { injectable } from "inversify";
import NotificationModel from "../infrastructure/models/Notification";

@injectable()
export class GetUserNotifications {
  async execute(userId: string) {
    const currentDate = new Date();
    
    // Fetch notifications from database
    const notifications = await NotificationModel.find({ userId }).lean();

    // Business logic for filtering
    return notifications.filter(notification => {
      // Non-pending notifications always included
      if (notification.status !== 'pending') return true;

      // Parse activity datetime
      const activityDateTime = this.parseActivityDateTime(
        notification.activityDate,
        notification.activityTime
      );

      // Include only if activity is in future
      return activityDateTime > currentDate;
    });
  }

  private parseActivityDateTime(date?: string, time?: string): Date {
    if (!date || !time) return new Date(0); // Invalid date

    const [day, month, year] = date.split('-').map(Number);
    const timeMatch = time.match(/(\d+):(\d+) (AM|PM)/i);

    if (!timeMatch) return new Date(0);

    let hours = parseInt(timeMatch[1]);
    const minutes = parseInt(timeMatch[2]);
    const period = timeMatch[3].toUpperCase();

    // Convert to 24h format
    if (period === 'PM' && hours !== 12) hours += 12;
    if (period === 'AM' && hours === 12) hours = 0;

    return new Date(year, month - 1, day, hours, minutes);
  }
}