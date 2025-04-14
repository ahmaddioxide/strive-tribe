// src/activity/interface/http/validation.ts
import { Request, Response, NextFunction } from "express";
import { body, validationResult, query  } from "express-validator";

export const validateAddActivity = [
  body("user_id")
    .notEmpty().withMessage("User ID is required")
    .isString().withMessage("User ID must be a string"),
  
  body("selectActivity")
    .notEmpty().withMessage("Activity selection is required")
    .isIn(['Soccer',
    'Basketball',
    'Tennis',
    'Cricket',
    'Badminton',
    'Baseball'])
    .isString().withMessage("Invalid activity format"),

  body("selectPlayerLevel")
    .notEmpty().withMessage("Player level is required")
    .isIn(['Beginner', 'Intermediate', 'Professional'])
    .withMessage("Invalid player level"),

  body("selectDate")
    .notEmpty().withMessage("Date is required")
    .matches(/^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-\d{4}$/)
    .withMessage("Invalid date format (DD-MM-YYYY)"),

  body("selectTime")
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