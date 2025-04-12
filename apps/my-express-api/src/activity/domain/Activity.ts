// src/activity/domain/Activity.ts
export interface Activity {
    userId: string;
    selectActivity: string;
    selectPlayerLevel: string;
    selectDate: string; // DD-MM-YYYY format
    selectTime: string; // HH:MM AM/PM format
    notes?: string;
    videoUrl?: string;
    createdAt?: Date;
  }