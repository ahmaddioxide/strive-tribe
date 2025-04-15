// src/activity/interface/http/validation.ts
import { Request, Response, NextFunction } from "express";
import { body, validationResult, query  } from "express-validator";

export const validateAddActivity = [
  body("user_id")
    .notEmpty().withMessage("User ID is required")
    .isString().withMessage("User ID must be a string"),
  
  body("Activity")
    .notEmpty().withMessage("Activity selection is required")
    .isString().withMessage("Invalid activity format"),

  body("PlayerLevel")
    .notEmpty().withMessage("Player level is required")
    .isIn(['Beginner', 'Intermediate', 'Advanced'])
    .withMessage("Invalid player level"),

  body("Date")
    .notEmpty().withMessage("Date is required")
    .matches(/^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-\d{4}$/)
    .withMessage("Invalid date format (DD-MM-YYYY)"),

  body("Time")
    .notEmpty().withMessage("Time is required")
    .matches(/^(0?[1-9]|1[0-2]):[0-5][0-9]\s(AM|PM)$/i)
    .withMessage("Invalid time format (HH:MM AM/PM)"),

  (req: Request, res: Response, next: NextFunction) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ 
        success: false,
        errors: errors.array() 
      });
    }
    next();
  }
];

export const validateFindNearbyActivities = [
  query('activityName')
    .optional()
    .isString()
    .withMessage('Activity name must be a string'),
  query('playerLevel')
    .optional()
    .isString()
    .withMessage('Player level must be a string')
];


export const validateGetActivitiesByDateTime = [
  query('user_id').notEmpty().withMessage("User ID is required"),
  query('date').matches(/^\d{2}-\d{2}-\d{4}$/).withMessage("Date must be in DD-MM-YYYY format"),
  query('time').matches(/^\d{2}:\d{2} [AP]M$/).withMessage("Time must be in HH:MM AM/PM format")
];