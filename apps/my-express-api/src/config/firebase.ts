import * as admin from "firebase-admin";
import { Config } from "./config";

export function initializeFirebase(config: Config): void {
  if (!admin.apps.length) {
    admin.initializeApp({
      credential: admin.credential.cert(config.firebaseServiceAccount),
      databaseURL: config.firebaseDatabaseURL,
    });
  }
}
