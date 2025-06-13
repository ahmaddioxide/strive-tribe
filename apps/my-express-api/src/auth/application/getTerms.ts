// src/auth/application/getTerms.ts
import { injectable } from "inversify";
import TermsModel from "../infrastructure/models/TermsAndPolicies";

@injectable()
export class GetTerms {
  async execute() {
    try {
      // Get the latest terms document sorted by effective date
      const terms = await TermsModel.findOne().sort({ effectiveDate: -1 });
      
      if (!terms) {
        throw new Error("No terms and conditions found");
      }
      
      return {
        version: terms.version,
        content: terms.content,
        effectiveDate: terms.effectiveDate
      };
    } catch (error: any) {
      console.error("Failed to fetch terms:", error.message);
      throw new Error("Failed to fetch terms and conditions");
    }
  }
}