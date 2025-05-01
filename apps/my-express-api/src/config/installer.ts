import { Container } from "inversify";
import { Identifier } from "../constants/identifiers";
import { Config } from "./config";
import { Database } from "../database/index";
import { IDatabase } from "../database/IDatabase";
import AuthController from "../auth/interface/http/auth.controller";
import { ActivityController } from "../activity/interface/http/activity.controller";
import { FindNearbyActivities } from "../activity/application/FindNearbyActivities";
import { GetActivityDetails } from "../activity/application/GetUserActivitiesById";
import { RegisterUser } from "../auth/application/register";
import { LoginUser } from "../auth/application/login";
import { UpdateUser } from "../auth/application/update";
import { CheckUser } from "../auth/application/check";
import { GetUser } from "../auth/application/getUser";
import { AddActivity } from "../activity/application/AddActivity";
import { UpdateParticipationStatus } from "../activity/application/UpdateParticipationStatus";
import { GetUserNotifications } from "../activity/application/GetNotifications";
import { GetScheduledActivities } from "../activity/application/GetScheduledActivities";
import { GetUserStats } from "../../src/auth/application/GetUserStats";
import { FindNearbyPlayers } from "../auth/application/FindNearbyPlayers";


import { ParticipateActivity } from "../activity/application/ParticipateActivity";

let container = new Container();

container.bind<Config>(Identifier.Config).to(Config).inSingletonScope();
container.bind<Config>(Config).toService(Identifier.Config);

container.bind<IDatabase>(Identifier.DatabaseDriver).to(Database);
container.bind<RegisterUser>(RegisterUser).toSelf();
container.bind<LoginUser>(LoginUser).toSelf();
container.bind<UpdateUser>(UpdateUser).toSelf();
container.bind<CheckUser>(CheckUser).toSelf();
container.bind<GetUser>(GetUser).toSelf();
container.bind<AddActivity>(AddActivity).toSelf();
container.bind<FindNearbyActivities>(FindNearbyActivities).toSelf();
container.bind<GetActivityDetails>(GetActivityDetails).toSelf();
container.bind<ParticipateActivity>(ParticipateActivity).toSelf();
container.bind<UpdateParticipationStatus>(UpdateParticipationStatus).toSelf();
container.bind<GetUserNotifications>(GetUserNotifications).toSelf();
container.bind<GetScheduledActivities>(GetScheduledActivities).toSelf();
container.bind<GetUserStats>(GetUserStats).toSelf();
container.bind<FindNearbyPlayers>(FindNearbyPlayers).toSelf();
container.bind<AuthController>(Identifier.AuthController).to(AuthController);
container.bind<ActivityController>(Identifier.ActivityController).to(ActivityController);

export default container;