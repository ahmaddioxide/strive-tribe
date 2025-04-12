import { Container } from "inversify";
import { Identifier } from "../constants/identifiers";
import { Config } from "./config";
import { Database } from "../database/index";
import { IDatabase } from "../database/IDatabase";
import AuthController from "../auth/interface/http/auth.controller";
import { ActivityController } from "../activity/interface/http/activity.controller";
import { RegisterUser } from "../auth/application/register";
import { LoginUser } from "../auth/application/login";
import { UpdateUser } from "../auth/application/update";
import { CheckUser } from "../auth/application/check";
import { GetUser } from "../auth/application/getUser";
import { AddActivity } from "../activity/application/AddActivity";

let container = new Container();

container.bind<Config>(Identifier.config).to(Config).inSingletonScope();
container.bind<Config>(Config).toService(Identifier.config);

container.bind<IDatabase>(Identifier.databaseDriver).to(Database);
container.bind<RegisterUser>(RegisterUser).toSelf();
container.bind<LoginUser>(LoginUser).toSelf();
container.bind<UpdateUser>(UpdateUser).toSelf();
container.bind<CheckUser>(CheckUser).toSelf();
container.bind<GetUser>(GetUser).toSelf();
container.bind<AddActivity>(AddActivity).toSelf();
container.bind<AuthController>(Identifier.authController).to(AuthController);
container.bind<ActivityController>(Identifier.activityController).to(ActivityController);

export default container;