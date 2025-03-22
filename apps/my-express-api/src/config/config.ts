import { injectable } from "inversify";

@injectable()
export class Config {
    public enviorment:string ;
    public jwt_token_secret:string ;
    public port:number ;
    public database_url:string ;
    public fe_url:string;
    public fe_version:Number;
    
    constructor() {
        this.enviorment = process.env.LOBAY_BE_ENV;
        this.database_url = process.env.LOBAY_DB_URL;
        this.port = Number(process.env.LOBAY_PORT);
        this.jwt_token_secret = process.env.LOBAY_SECRET;
    }
}