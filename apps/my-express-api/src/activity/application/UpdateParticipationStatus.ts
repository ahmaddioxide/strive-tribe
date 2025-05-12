import { injectable, inject } from "inversify";
import mongoose from "mongoose";
import ParticipationModel from "../infrastructure/models/Participation";
import ActivityModel from "../infrastructure/models/Activity";
import RequestActivityModel from "../infrastructure/models/RequestActivity";
import UserModel from "../../auth/infrastructure/models/User";
import NotificationModel from "../infrastructure/models/Notification";
import { Config } from "../../config/config";

@injectable()
export class UpdateParticipationStatus {
  constructor(@inject(Config) private config: Config) {}

  private parseActivityDateTime(dateStr: string, timeStr: string): Date {
    if (!dateStr || !timeStr) {
      throw new Error("Date or time field is missing");
    }

    const [day, month, year] = dateStr.split('-').map(Number);
    const timeMatch = timeStr.match(/^(\d{1,2}):(\d{2})\s?(AM|PM)$/i);

    if (!timeMatch) {
      throw new Error(`Invalid time format: '${timeStr}'`);
    }

    let hours = parseInt(timeMatch[1]);
    const minutes = parseInt(timeMatch[2]);
    const period = timeMatch[3].toUpperCase();

    if (period === 'PM' && hours !== 12) hours += 12;
    if (period === 'AM' && hours === 12) hours = 0;

    return new Date(year, month - 1, day, hours, minutes);
  }

  private formatActivityEntry(
    activity: any,
    partnerName: string,
    userId: string,
    isRequestActivity: boolean
  ): object {
    return {
      activityId: activity._id.toString(),
      userId: userId,
      activity: isRequestActivity ? activity.activityName : activity.Activity,
      partnerName: partnerName,
      playerLevel: isRequestActivity ? activity.activityLevel : activity.PlayerLevel,
      date: isRequestActivity ? activity.activityDate : activity.Date,
      time: isRequestActivity ? activity.activityTime : activity.Time,
    };
  }

  async execute(id: string, status: 'accepted' | 'declined', notificationId?: string) {
    const participation = await ParticipationModel.findById(id);
    if (!participation) throw new Error("Participation record not found");

    // Try to find in Activity collection first
    let activity = await ActivityModel.findById(participation.activityId);
    let isRequestActivity = false;

    // If not found, check RequestActivity collection
    if (!activity) {
      activity = await RequestActivityModel.findOne({
        activityId: participation.activityId.toString()
      });

      if (!activity) {
        throw new Error("Associated activity not found");
      }
      isRequestActivity = true;
    }

    // Handle acceptance validation
    if (status === 'accepted') {
      const dateField = isRequestActivity 
        ? (activity as any).activityDate 
        : (activity as any).Date;

      const timeField = isRequestActivity 
        ? (activity as any).activityTime 
        : (activity as any).Time;

      const activityDateTime = this.parseActivityDateTime(dateField, timeField);
      if (new Date() >= activityDateTime) {
        throw new Error("Cannot accept - activity has already occurred");
      }
    }

    // Update participation status
    const updatedParticipation = await ParticipationModel.findByIdAndUpdate(
      id,
      { status },
      { new: true }
    );

    // Update notification if provided
    if (notificationId) {
      await NotificationModel.findByIdAndUpdate(notificationId, {
        status,
        read: true,
      });
    }

    // Update RequestActivity status if applicable
    if (isRequestActivity) {
      await RequestActivityModel.findByIdAndUpdate(
        activity._id,
        { status },
        { new: true }
      );
    }

    // Handle acceptance logic
    if (status === 'accepted' && updatedParticipation) {
      let creatorId: string;
      let participantId: string;

      if (isRequestActivity) {
        // For request activities
        creatorId = (activity as any).reqFrom; // Original requester
        participantId = (activity as any).reqTo; // The user being requested
      } else {
        // For regular activities
        creatorId = (activity as any).userId; // Activity owner
        participantId = participation.userId; // Participant
      }

      const [creatorUser, participantUser] = await Promise.all([
        UserModel.findOne({ userId: creatorId }),
        UserModel.findOne({ userId: participantId })
      ]);

      if (!creatorUser || !participantUser) {
        throw new Error("User records not found");
      }

      const activityId = activity._id.toString();
      const activityDate = isRequestActivity 
        ? (activity as any).activityDate 
        : (activity as any).Date;
      const activityTime = isRequestActivity 
        ? (activity as any).activityTime 
        : (activity as any).Time;

      // Check for existing scheduled activities
      const [creatorHasActivity, participantHasActivity] = await Promise.all([
        UserModel.countDocuments({
          _id: creatorUser._id,
          'scheduledActivities.activityId': activityId,
          'scheduledActivities.date': activityDate,
          'scheduledActivities.time': activityTime
        }),
        UserModel.countDocuments({
          _id: participantUser._id,
          'scheduledActivities.activityId': activityId,
          'scheduledActivities.date': activityDate,
          'scheduledActivities.time': activityTime
        })
      ]);

      if (creatorHasActivity > 0 || participantHasActivity > 0) {
        throw new Error("Same activity already scheduled at this date/time");
      }

      // Create entries for both users
      const creatorEntry = this.formatActivityEntry(
        activity,
        participantUser.name,
        participantId,
        isRequestActivity
      );

      const participantEntry = this.formatActivityEntry(
        activity,
        creatorUser.name,
        creatorId,
        isRequestActivity
      );

      // Update both users' schedules
      await Promise.all([
        UserModel.findByIdAndUpdate(
          creatorUser._id,
          { $addToSet: { scheduledActivities: creatorEntry } }
        ),
        UserModel.findByIdAndUpdate(
          participantUser._id,
          { $addToSet: { scheduledActivities: participantEntry } }
        )
      ]);
    }

    return updatedParticipation;
  }
}