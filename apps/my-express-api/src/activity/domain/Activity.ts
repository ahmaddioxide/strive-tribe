// src/activity/domain/Activity.ts
export interface Activity {
    userId: string;
    Activity: string;
    PlayerLevel: string;
    Date: string; // DD-MM-YYYY format
    Time: string; // HH:MM AM/PM format
    notes?: string;
    videoUrl?: string;
    createdAt?: Date;
  }