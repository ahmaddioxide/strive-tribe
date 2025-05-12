// src/request_activity/domain/RequestActivity.ts
export interface RequestActivity {
    reqFrom: string;
    reqTo: string;
    activityId: string;
    activityName: string;
    activityLevel: string;
    activityDate: string; // DD-MM-YYYY format
    activityTime: string; // HH:MM AM/PM format
    note?: string;
    status?: string; // 'pending', 'accepted', 'declined'
    videoUrl?: string;
    createdAt?: Date;
}