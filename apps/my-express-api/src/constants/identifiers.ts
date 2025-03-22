export class Identifier {
    public static mongoUserRepository = Symbol("MongoUserRepostiory");
    public static databaseDriver = Symbol("DatabaseDriver");
    public static config = Symbol("Config");
    public static authController = Symbol("authController");
    
    public static createUser = Symbol("createUser");
}
