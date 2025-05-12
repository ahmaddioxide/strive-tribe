// // src/activity/application/ParticipateActivity.ts
// import { injectable, inject } from "inversify";
// import ParticipationModel from "../infrastructure/models/Participation";
// import ActivityModel from "../infrastructure/models/Activity";
// import UserModel from "../../auth/infrastructure/models/User";
// import NotificationModel from "../../activity/infrastructure/models/Notification";
// import { Config } from "../../config/config";

// @injectable()
// export class ParticipateActivity {
//   constructor(
//     @inject(Config) private config: Config
//   ) {}

//   async execute(activityId: string, userId: string) {
//     try {
//       // Existing participation check
//       const exists = await ParticipationModel.findOne({ activityId, userId });
//       if (exists) throw new Error("User already joined this activity");

//       // Get activity details
//       const activity = await ActivityModel.findById(activityId);
//       if (!activity) throw new Error("Activity not found");

//       // Date/Time Validation
//       const [day, month, year] = activity.Date.split('-').map(Number);
//       const timeMatch = activity.Time.match(/(\d+):(\d+) (AM|PM)/i);
      
//       if (!timeMatch) throw new Error("Invalid activity time format");

//       let hours = parseInt(timeMatch[1], 10);
//       const minutes = parseInt(timeMatch[2], 10);
//       const period = timeMatch[3].toUpperCase();

//       if (period === 'PM' && hours !== 12) hours += 12;
//       if (period === 'AM' && hours === 12) hours = 0;

//       const activityDate = new Date(year, month - 1, day, hours, minutes);
//       if (new Date() >= activityDate) {
//         throw new Error("Activity has already started or ended");
//       }

//       // Create participation record
//       const participation = new ParticipationModel({
//         activityId,
//         userId,
//         status: 'pending'
//       });
//       await participation.save();

//       // Update participants count
//       await ActivityModel.findByIdAndUpdate(activityId, { $inc: { participantsCount: 1 } });

//       // Get user details
//       const requestingUser = await UserModel.findOne({ userId });
//       if (!requestingUser) throw new Error("User not found");

//       // Create and save notification
//       const notification = new NotificationModel({
//         userId: activity.userId,
//         title: `${requestingUser.name} is requesting to play`,
//         message: `${activity.Activity} on ${activity.Date} at ${activity.Time}`,
//         profileImage: requestingUser.profileImage || '',
//         activityId,
//         requesterId: userId,
//         activityDate: activity.Date,
//         activityTime: activity.Time,
//         read: false,
//         status: 'pending'
//       });
//       await notification.save();

//       return {
//         success: true,
//         message: "Join request submitted successfully",
//         participation: {
//           id: participation._id,
//           activityId: participation.activityId,
//           userId: participation.userId,
//           status: participation.status,
//           joinedAt: participation.joinedAt,
//           userName: requestingUser.name,
//           activityDetails: {
//             activity: activity.Activity,
//             date: activity.Date,
//             time: activity.Time
//           }
//         },
//         notificationId: notification._id.toString()
//       };
//     } catch (error: any) {
//       console.error("Participation error:", error);
//       throw new Error(error.message || "Failed to join activity");
//     }
//   }
// }


import { injectable, inject } from "inversify";
import ParticipationModel from "../infrastructure/models/Participation";
import ActivityModel from "../infrastructure/models/Activity";
import UserModel from "../../auth/infrastructure/models/User";
import NotificationModel from "../../activity/infrastructure/models/Notification";
import { Config } from "../../config/config";

@injectable()
export class ParticipateActivity {
  constructor(
    @inject(Config) private config: Config
  ) {}

  async execute(activityId: string, userId: string) {
    try {
      const exists = await ParticipationModel.findOne({ activityId, userId });
      if (exists) throw new Error("User already joined this activity");

      const activity = await ActivityModel.findById(activityId);
      if (!activity) throw new Error("Activity not found");

      const [day, month, year] = activity.Date.split('-').map(Number);
      const timeMatch = activity.Time.match(/(\d+):(\d+) (AM|PM)/i);
      if (!timeMatch) throw new Error("Invalid activity time format");

      let hours = parseInt(timeMatch[1], 10);
      const minutes = parseInt(timeMatch[2], 10);
      const period = timeMatch[3].toUpperCase();

      if (period === 'PM' && hours !== 12) hours += 12;
      if (period === 'AM' && hours === 12) hours = 0;

      const activityDate = new Date(year, month - 1, day, hours, minutes);
      if (new Date() >= activityDate) {
        throw new Error("Activity has already started or ended");
      }

      const participation = new ParticipationModel({
        activityId,
        userId,
        status: 'pending'
      });
      await participation.save();

      await ActivityModel.findByIdAndUpdate(activityId, { $inc: { participantsCount: 1 } });

      const requestingUser = await UserModel.findOne({ userId });
      if (!requestingUser) throw new Error("User not found");

      const notification = new NotificationModel({
        userId: activity.userId,
        title: `${requestingUser.name} is requesting to play`,
        message: `${activity.Activity} on ${activity.Date} at ${activity.Time}`,
        profileImage: requestingUser.profileImage || '',
        activityId,
        requesterId: userId,
        activityDate: activity.Date,
        activityTime: activity.Time,
        read: false,
        status: 'pending'
      });
      await notification.save();

      // 🔔 FETCH ACTIVITY OWNER'S DEVICE TOKEN
      const activityOwner = await UserModel.findOne({ userId: activity.userId });
      const deviceToken = activityOwner?.deviceToken;

      // ✅ SEND NOTIFICATION IF DEVICE TOKEN EXISTS
      if (deviceToken) {
        const admin = this.config.initializeFirebase();
        await admin.messaging().send({
          token: deviceToken,
          notification: {
            title: `${requestingUser.name} is requesting to play`,
            body: `${activity.Activity} on ${activity.Date} at ${activity.Time}`
          },
          data: {
            activityId: activityId,
            requesterId: userId,
            type: 'join_request'
          }
        });
      }

      return {
        success: true,
        message: "Join request submitted successfully",
        participation: {
          id: participation._id,
          activityId: participation.activityId,
          userId: participation.userId,
          status: participation.status,
          joinedAt: participation.joinedAt,
          userName: requestingUser.name,
          activityDetails: {
            activity: activity.Activity,
            date: activity.Date,
            time: activity.Time
          }
        },
        notificationId: notification._id.toString()
      };
    } catch (error: any) {
      console.error("Participation error:", error);
      throw new Error(error.message || "Failed to join activity");
    }
  }
}
