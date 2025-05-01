import { injectable, inject } from "inversify";
import ParticipationModel from "../infrastructure/models/Participation";
import ActivityModel from "../infrastructure/models/Activity";
import UserModel from "../../auth/infrastructure/models/User";
import NotificationModel from "../infrastructure/models/Notification";
import { Config } from "../../config/config";

@injectable()
export class UpdateParticipationStatus {
  constructor(@inject(Config) private config: Config) {}

  private parseActivityDateTime(dateStr: string, timeStr: string): Date {
    const [day, month, year] = dateStr.split('-').map(Number);
    const timeMatch = timeStr.match(/^(\d{1,2}):(\d{2})\s(AM|PM)$/i);
    if (!timeMatch) throw new Error("Invalid time format");

    let hours = parseInt(timeMatch[1]);
    const minutes = parseInt(timeMatch[2]);
    const period = timeMatch[3].toUpperCase();

    if (period === 'PM' && hours !== 12) hours += 12;
    if (period === 'AM' && hours === 12) hours = 0;

    return new Date(year, month - 1, day, hours, minutes);
  }

  /*private formatActivityEntry(activity: any, partnerName: string): string {
    return `${activity.Activity} with ${partnerName} on ${activity.Date} at ${activity.Time}`;
  }*/

  private formatActivityEntry(activity: any, partnerName: string): object {
    return {
      activityId: activity._id,
      activity: activity.Activity,
      partnerName: partnerName,
      playerLevel: activity.PlayerLevel,
      date: activity.Date,
      time: activity.Time,
    };
  }

  async execute(id: string, status: 'accepted' | 'declined', notificationId?: string) {
    const participation = await ParticipationModel.findById(id)
      .populate({
        path: 'activityId',
        select: 'Date Time Activity userId PlayerLevel',
      });
  
    if (!participation) {
      throw new Error("Participation record not found");
    }
  
    if (!participation.activityId) {
      throw new Error("Associated activity not found");
    }
  
    const activity = participation.activityId as any;
  
    if (status === 'accepted') {
      const activityDateTime = this.parseActivityDateTime(activity.Date, activity.Time);
      if (new Date() >= activityDateTime) {
        throw new Error("Cannot accept - activity has already occurred");
      }
    }
  
    const updatedParticipation = await ParticipationModel.findByIdAndUpdate(
      id,
      { status },
      { new: true }
    );
  
    if (notificationId) {
      await NotificationModel.findByIdAndUpdate(
        notificationId,
        { status, read: true }
      );
    }
  
    if (status === 'accepted' && updatedParticipation) {
      const [requester, creator] = await Promise.all([
        UserModel.findOne({ userId: participation.userId }),
        UserModel.findOne({ userId: activity.userId })
      ]);
  
      if (!requester || !creator) {
        throw new Error("User records not found");
      }
  
      // 🔽🔽🔽 Added duplicate check using activityId 🔽🔽🔽
      const activityId = activity._id.toString();
      
      const [requesterHasActivity, creatorHasActivity] = await Promise.all([
        UserModel.countDocuments({
          _id: requester._id,
          'scheduledActivities.activityId': activityId
        }),
        UserModel.countDocuments({
          _id: creator._id,
          'scheduledActivities.activityId': activityId
        })
      ]);
  
      if (requesterHasActivity > 0 || creatorHasActivity > 0) {
        throw new Error("Activity already scheduled for one of the participants");
      }
      // 🔼🔼🔼 End of duplicate check 🔼🔼🔼
  
      const requesterEntry = this.formatActivityEntry(activity, creator.name);
      const creatorEntry = this.formatActivityEntry(activity, requester.name);
  
      await Promise.all([
        UserModel.findByIdAndUpdate(
          requester._id,
          { $addToSet: { scheduledActivities: requesterEntry } }
        ),
        UserModel.findByIdAndUpdate(
          creator._id,
          { $addToSet: { scheduledActivities: creatorEntry } }
        )
      ]);
    }
  
    return updatedParticipation;
  }
}