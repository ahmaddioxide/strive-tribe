import { injectable, inject } from "inversify";
import UserModel from "../infrastructure/models/User";
import jwt from "jsonwebtoken";
import { Config } from "../../config/config";

@injectable()
export class LoginUser {
  constructor(
    @inject(Config) private config: Config
  ) {}

  async execute(userId: string) {
    // ✅ Initialize Firebase Admin
    const firebase = this.config.initializeFirebase();

    // ✅ Verify Firebase user exists
    try {
      await firebase.auth().getUser(userId);
    } catch (error: any) {
      if (error.code === 'auth/user-not-found') {
        throw new Error('User not registered in Firebase. Please authenticate first.');
      }
      throw new Error(`Firebase verification failed: ${error.message}`);
    }

    // ✅ Check user in local DB
    const user = await UserModel.findOne({ userId });

    if (!user) {
      throw new Error("User not registered");
    }

    // ✅ Generate JWT token
    const token = jwt.sign(
      { id: user._id, userId: user.userId },
      this.config.jwt_token_secret,
      { expiresIn: "30d" }
    );

    return {
      token,
      user: {
        id: user._id,
        userId: user.userId,
        name: user.name,
        email: user.email,
        profileImage: user.profileImage,
        signInWith: user.signInWith
      }
    };
  }
}
