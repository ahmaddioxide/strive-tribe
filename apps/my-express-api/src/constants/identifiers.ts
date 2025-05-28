// src/constants/identifiers.ts
export class Identifier {
    public static DatabaseDriver = Symbol("DatabaseDriver");
    public static Config = Symbol("Config"); // Changed to PascalCase
    public static AuthController = Symbol("AuthController");
    public static ActivityController = Symbol("ActivityController");
    public static ChatController = Symbol("ChatController");
}