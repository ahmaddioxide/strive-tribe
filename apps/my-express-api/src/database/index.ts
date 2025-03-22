import mongoose, { ConnectOptions } from 'mongoose'
import { IDatabase } from './IDatabase';
import {  injectable,inject } from "inversify";
import {  Identifier } from "../constants/identifiers";

@injectable()
export class Database implements IDatabase {
  mongoConnectionString:string;
  constructor(
    @inject(Identifier.config) config:any
  ){
    this.mongoConnectionString = config.database_url;
  }
  
  async connect(){
    const options:ConnectOptions = {};
    var db = mongoose.connection;
    db.on("error", console.error.bind(console, "MongoDB Connection error"));
    return mongoose.connect(this.mongoConnectionString, options);
  }
}
