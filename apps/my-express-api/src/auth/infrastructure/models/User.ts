import mongoose, { Schema, Document, Query } from "mongoose";

export interface IUserModel extends Document {
  username: string;
  active: boolean;
  hash_password: string;
  gender: string;
  system_role: string;
  first_name: string;
  last_name: string;
  father_name: string;
  cnic: string;
  date_of_birth: Date;
  email: string;
  phone_number: string;
  landline_number: string;
  address_1: string;
  address_2: string;
  qualification: string;
  designation:string;
  joiningDate: Date;
  departureDate: Date;
  site: string;
  id: string;
  lastLoginTimeStamp: Date;
  firstTimeLogin:boolean;

}

const UserSchema: Schema = new Schema({
  username: { type: String },
  active: { type: Boolean },
  hash_password: { type: String },
  system_role: { type: String },
  first_name: { type: String },
  gender: { type: String },
  last_name: { type: String },
  father_name: { type: String },
  cnic: { type: String },
  date_of_birth: { type: Date },
  email: { type: String,unique:true },
  phone_number: { type: String },
  landline_number: { type: String },
  address_1: { type: String },
  address_2: { type: String },
  qualification: { type: String },
  designation: { type: String },
  joiningDate: { type: Date },
  departureDate: { type: Date },
  site: { type: String},
  lastLoginTimeStamp: { type: Date },
  firstTimeLogin: { type: Boolean, default:false},

  _id: { type: String }
}, { timestamps: true });

const UserModel = mongoose.model<IUserModel>("user", UserSchema);
export default UserModel;
