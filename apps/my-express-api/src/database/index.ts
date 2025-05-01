import mongoose, { ConnectOptions } from 'mongoose'
import { IDatabase } from './IDatabase';
import { injectable, inject } from "inversify";
import { Config } from "../config/config";

@injectable()
export class Database implements IDatabase {
  mongoConnectionString: string;

  constructor(
    @inject(Config) private config: Config
  ) {
    this.mongoConnectionString = config.database_url;
  }
  
  async connect() {
    const options: ConnectOptions = {
      connectTimeoutMS: 5000,
      socketTimeoutMS: 30000,
    };
    
    try {
      await mongoose.connect(this.mongoConnectionString, options);
      console.log('MongoDB connected successfully');
    } catch (error) {
      console.error('MongoDB connection error:', error);
      throw error;
    }
  }
}