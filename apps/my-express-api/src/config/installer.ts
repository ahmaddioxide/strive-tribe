import { Container } from "inversify";

import { Identifier } from "../constants/identifiers";
import { Config } from "./config";
import { Database } from "../database/index";
import { IDatabase } from "../database/IDatabase";
import AuthController from "../auth/interface/http/auth.controller";
import { CreateUser } from "../auth/application/register";

let container = new Container();
container.bind<IDatabase>(Identifier.databaseDriver).to(Database);
container.bind<AuthController>(Identifier.authController).to(AuthController);
container.bind<Config>(Identifier.config).to(Config).inSingletonScope();
container.bind<CreateUser>(Identifier.createUser).to(CreateUser);

export default container;