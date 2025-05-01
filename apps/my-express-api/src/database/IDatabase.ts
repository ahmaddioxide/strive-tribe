export interface IDatabase {
    mongoConnectionString:string;
    connect():Promise<any>;
  }
  