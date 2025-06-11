// src/auth/application/reportProblem.ts
import { injectable } from "inversify";
import ProblemReportModel from "../infrastructure/models/ProblemReport";

@injectable()
export class ReportProblem {
  async execute(name: string, email: string, description: string) {
    try {
      const report = new ProblemReportModel({
        name,
        email,
        description
      });

      await report.save();
      
      return {
        id: report._id,
        name: report.name,
        email: report.email,
        createdAt: report.createdAt
      };
    } catch (error: any) {
      console.error("Problem report failed:", error.message);
      throw new Error("Failed to submit problem report");
    }
  }
}