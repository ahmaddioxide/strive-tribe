// src/config/firebase.ts
import { Config } from "./config";
import * as admin from 'firebase-admin';

export function initializeFirebase(config: Config) {
    try {
        const firebaseApp = config.initializeFirebase();
        console.log('Firebase Admin initialized successfully');
        return firebaseApp;
    } catch (error) {
        console.error('Firebase initialization error:', error);
        throw error;
    }
}