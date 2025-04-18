import { injectable, inject } from "inversify";
import { Types } from "mongoose";
import UserModel from "../../auth/infrastructure/models/User";
import ActivityModel from "../infrastructure/models/Activity";
import { Config } from "../../config/config";
import { profile } from "console";

@injectable()
export class GetActivityDetails {
  constructor(
    @inject(Config) private config: Config
  ) {}

  async execute(activityId: string) {
    try {
      // 1. Validate activity ID format
      if (!Types.ObjectId.isValid(activityId)) {
        throw new Error("Invalid activity ID format");
      }

      // 2. Find the activity by ID
      const activity = await ActivityModel.findById(activityId).lean();
      if (!activity) {
        throw new Error("Activity not found");
      }

      // 3. Find associated user details
      const user = await UserModel.findOne({ userId: activity.userId })
        .select('name countryName state placeName profileImage')
        .lean();

      if (!user) {
        throw new Error("User not found for this activity");
      }

      // 4. Format the response
      return {
        success: true,
        data: {
          activity: {
            _id: activity._id,
            Activity: activity.Activity,
            PlayerLevel: activity.PlayerLevel,
            Date: activity.Date,
            Time: activity.Time,
            notes: activity.notes,
            videoUrl: activity.videoUrl,
            createdAt: activity.createdAt
          },
          userDetails: {
            name: user.name,
            countryName: user.countryName,
            state: user.state,
            placeName: user.placeName,
            profilePicture: user.profileImage 
            // Assuming profileImageUrl is the correct field name in the User model
            // Remove profilePicture as it does not exist on the user object
                        // profilePicture: user.profilePicture
          }
        }
      };
    } catch (error: any) {
      console.error("GetActivityDetails error:", error);
      throw new Error(error.message || "Failed to fetch activity details");
    }
  }
}