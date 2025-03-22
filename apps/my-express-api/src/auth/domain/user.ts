export class User {
    public firstName: string;
    public lastName: string;
    public dateOfBirth: Date;
    public email: string;
    public phoneNumber: string;
    public profilePictureUrl: string;
    private passwordHash: string;
}