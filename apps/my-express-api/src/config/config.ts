// src/config/config.ts
import { injectable } from "inversify";
import * as admin from 'firebase-admin';

@injectable()
export class Config {
    // Core App Config
    public environment: string;
    public jwt_token_secret: string;
    public port: number;
    public database_url: string;
    
    // Firebase
    public firebaseProjectId: string;
    public firebaseStorageBucket: string;
    public firebaseApiKey: string;
    public firebaseClientEmail: string;
    public firebasePrivateKey: string;
    public firebaseServiceAccount: admin.ServiceAccount;
    public firebaseDatabaseURL: string;
    
    // Google Services
    public googleMapsApiKey: string;
    
    constructor() {
        // Core App Config
        this.environment = process.env.LOBAY_BE_ENV || "development";
        this.database_url = process.env.LOBAY_DB_URL || "";
        this.port = Number(process.env.LOBAY_PORT) || 3000;
        this.jwt_token_secret = process.env.LOBAY_SECRET || "default_secret";
        
        // Firebase
        this.firebaseProjectId = process.env.FIREBASE_PROJECT_ID || "";
        this.firebaseStorageBucket = process.env.FIREBASE_STORAGE_BUCKET || "";
        this.firebaseApiKey = process.env.FIREBASE_API_KEY || "";
        this.firebaseClientEmail = process.env.FIREBASE_CLIENT_EMAIL || "";
        this.firebasePrivateKey = process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n') || "";
        
        // Google Maps
        this.googleMapsApiKey = process.env.GOOGLE_MAPS_API_KEY || "";
    }
    
    public initializeFirebase() {
        if (!admin.apps.length) {
            admin.initializeApp({
                credential: admin.credential.cert({
                    projectId: this.firebaseProjectId,
                    clientEmail: this.firebaseClientEmail,
                    privateKey: this.firebasePrivateKey
                }),
                storageBucket: this.firebaseStorageBucket
            });
        }
        return admin;
    }
}