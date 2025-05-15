import { injectable, inject } from "inversify";
import mongoose from "mongoose";
import RequestActivityModel from "../infrastructure/models/RequestActivity";
import { RequestActivity } from "../domain/RequestActivity";
import * as firebaseAdmin from "firebase-admin";
import { Config } from "../../config/config";
import UserModel from "../../auth/infrastructure/models/User";
import NotificationModel from "../../activity/infrastructure/models/Notification";
import Participation from "../infrastructure/models/Participation";

@injectable()
export class SendRequestActivity {
  private readonly MAX_VIDEO_SIZE = 200 * 1024 * 1024; // 200MB

  constructor(
    @inject(Config) private config: Config
  ) {}

  async execute(requestData: RequestActivity, videoBase64?: string) {
    try {
      // 1. Prevent self-request
      if (requestData.reqFrom === requestData.reqTo) {
        throw new Error("Cannot send activity request to yourself");
      }

      // 2. Fetch the recipient user to find the matching activity
      const recipientUser = await UserModel.findOne({ userId: requestData.reqTo });
      if (!recipientUser) {
        throw new Error("Recipient user not found");
      }

      // 3. Find matching activity from recipient's activities
      const matchedActivity = recipientUser.activities.find(
        (activity: any) =>
          activity.name === requestData.activityName &&
          activity.expertise_level === requestData.activityLevel
      );

      if (!matchedActivity) {
        throw new Error("Matching activity not found for recipient");
      }

      const activityId = (matchedActivity as any)._id.toString();

      // 4. Check for existing activity request
      const existingRequest = await RequestActivityModel.findOne({
        reqFrom: requestData.reqFrom,
        reqTo: requestData.reqTo,
        activityId
      });

      if (existingRequest) {
        throw new Error("Request already sent for this activity");
      }

      let videoUrl = "";

      // 5. Handle video upload
      if (videoBase64) {
        const base64Data = videoBase64.replace(/^data:video\/\w+;base64,/, '');
        const buffer = Buffer.from(base64Data, 'base64');

        if (buffer.length > this.MAX_VIDEO_SIZE) {
          throw new Error("Video size exceeds 200MB limit");
        }

        const bucket = firebaseAdmin.storage().bucket();
        const fileName = `request_videos/${Date.now()}_${Math.random().toString(36).substring(2, 8)}.mp4`;
        const file = bucket.file(fileName);

        await file.save(buffer, {
          metadata: {
            contentType: 'video/mp4',
            metadata: {
              originalName: fileName,
              uploadedAt: new Date().toISOString()
            }
          }
        });

        await file.makePublic();
        videoUrl = `https://storage.googleapis.com/${bucket.name}/${fileName}`;
      }

      // 6. Save request activity
      const newRequest = new RequestActivityModel({
        ...requestData,
        activityId,
        videoUrl
      });
      await newRequest.save();

      // 7. Handle participation
      const activityObjectId = new mongoose.Types.ObjectId(activityId);

      const existingParticipation = await Participation.findOne({
        activityId: activityObjectId,
        userId: requestData.reqFrom
      });

      if (existingParticipation) {
        throw new Error("User already invited to this activity");
      }

      await Participation.create({
        activityId: activityObjectId,
        userId: requestData.reqFrom,
        status: 'pending'
      });

      // 8. Get user details for notification
      const requester = await UserModel.findOne({ userId: requestData.reqFrom });
      if (!requester) {
        throw new Error("Requester user not found");
      }

      // 9. Create notification
      const notification = new NotificationModel({
        userId: requestData.reqTo,
        title: `${requester.name} requested to play`,
        message: `Activity: ${requestData.activityName}, Date: ${requestData.activityDate}, Time: ${requestData.activityTime}`,
        profileImage: requester.profileImage,
        activityId,
        requesterId: requestData.reqFrom,
        activityDate: requestData.activityDate,
        activityTime: requestData.activityTime
      });
      await notification.save();

      // 10. Send Firebase notification
      if (recipientUser.deviceToken) {
        await firebaseAdmin.messaging().send({
          token: recipientUser.deviceToken,
          notification: {
            title: notification.title,
            body: notification.message
          },
          data: {
            notificationId: notification._id.toString(),
            type: 'activity_request'
          }
        });
      }

      return {
        success: true,
        message: "Request sent successfully",
        data: {
          id: newRequest._id.toString(),
          ...requestData,
          activityId,
          videoUrl,
          createdAt: newRequest.createdAt
        }
      };
    } catch (error: any) {
      console.error("Request failed:", error);

      const errorMessage = error.message.includes("already")
        ? error.message
        : error.code === 11000
        ? "Duplicate request detected"
        : error.message || "Failed to send request";

      throw new Error(errorMessage);
    }
  }
}
