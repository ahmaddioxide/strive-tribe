import { inject, injectable } from "inversify";

@injectable()
export class CreateUser {
    constructor(
    ) {
    }

    async execute() {
      console.log('Reached here');
    }

}



