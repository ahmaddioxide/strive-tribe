import { injectable, inject } from "inversify";
import ActivityModel from "../infrastructure/models/Activity";
import { Activity } from "../domain/Activity";
import * as firebaseAdmin from "firebase-admin";
import { Config } from "../../config/config";

@injectable()
export class AddActivity {
  private readonly MAX_VIDEO_SIZE = 200 * 1024 * 1024; // 200MB

  constructor(
    @inject(Config) private config: Config
  ) {}

  async execute(activityData: Activity, videoBase64?: string) {
    try {
      let videoUrl = "";
      
      if (videoBase64) {
        const base64Data = videoBase64.replace(/^data:video\/\w+;base64,/, '');
        const buffer = Buffer.from(base64Data, 'base64');

        if (buffer.length > this.MAX_VIDEO_SIZE) {
          throw new Error("Video size exceeds 200MB limit");
        }

        const bucket = firebaseAdmin.storage().bucket();
        const fileName = `activity_videos/${Date.now()}_${Math.random().toString(36).substring(2, 8)}.mp4`;
        const file = bucket.file(fileName);

        // Upload video
        await file.save(buffer, {
          metadata: {
            contentType: 'video/mp4',
            metadata: {
              originalName: fileName,
              uploadedAt: new Date().toISOString()
            }
          }
        });

        // Make file publicly accessible
        await file.makePublic();
        
        // Get permanent URL
        videoUrl = `https://storage.googleapis.com/${bucket.name}/${fileName}`;
      }

      // Save to database
      const newActivity = new ActivityModel({
        ...activityData,
        videoUrl
      });

      await newActivity.save();

      return {
        success: true,
        message: "Activity created successfully",
        data: {
          id: newActivity._id.toString(),
          userId: newActivity.userId,
          activity: newActivity.Activity,
          playerLevel: newActivity.PlayerLevel,
          date: newActivity.Date,
          time: newActivity.Time,
          videoUrl: newActivity.videoUrl,
          createdAt: newActivity.createdAt
        }
      };
    } catch (error: any) {
      console.error("Activity creation failed:", error);
      throw new Error(error.message || "Activity creation failed. Please try again.");
    }
  }
}