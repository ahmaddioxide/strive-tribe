import { injectable } from "inversify";
import UserModel from "../infrastructure/models/User";

@injectable()
export class GetCommonActivities {
  async execute(reqFrom: string, reqTo: string) {
    const [fromUser, toUser] = await Promise.all([
      UserModel.findOne({ userId: reqFrom }).select('activities').lean(),
      UserModel.findOne({ userId: reqTo }).select('activities').lean(),
    ]);

    if (!fromUser || !toUser) {
      throw new Error("One or both users not found");
    }

    const fromActivities = fromUser.activities || [];
    const toActivities = toUser.activities || [];

    const common = fromActivities.filter(fromAct =>
      toActivities.some(toAct =>
        toAct.name === fromAct.name && toAct.expertise_level === fromAct.expertise_level
      )
    );

    // Remove _id field from each activity
    const commonWithoutId = common.map(activity => {
      const { _id, ...rest } = activity as unknown as { _id: string; [key: string]: any };
      return rest;
    });

    return commonWithoutId;
  }
}
