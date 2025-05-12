// src/activity/interface/http/validation.ts
import { Request, Response, NextFunction } from "express";
import { body, validationResult, query, param  } from "express-validator";

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


export const validateActivityId = [
  param('id')
    .notEmpty().withMessage("Activity ID is required")
    .isMongoId().withMessage("Invalid activity ID format"),
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

export const validateJoinActivity = [
  query('userId')
    .notEmpty().withMessage("Invalid user ID"),
  query('activityId')
    .isMongoId().notEmpty().withMessage("Invalid activity ID"),
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

export const validateUpdateParticipationStatus = [
  param('id')
    .notEmpty().isMongoId().withMessage("Participation ID is required")
    .isMongoId().withMessage("Invalid participation ID format"),

  body('status')
    .notEmpty().withMessage("Status is required")
    .isIn(['accepted', 'declined'])
    .withMessage("Invalid status. Must be 'accepted' or 'declined'"),

  body('notificationId')
    .notEmpty().withMessage("Notification ID is required")
    .isMongoId().withMessage("Invalid notification ID format"),

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
export const validateGetNotifications = [
  param('userId')
    .notEmpty().withMessage("User ID is required")
    .withMessage("Invalid User ID format"),


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

// 1. Validation (add to existing validation file)
// src/auth/interface/http/validation.ts
export const validateGetScheduledActivities = [
  param('userId')
    .notEmpty().withMessage('User ID is required')
    .isMongoId().withMessage('Invalid user ID format'),
  query('activity')
    .optional()
    .isString()
    .withMessage('Activity filter must be a comma-separated string'),
  query('playerLevel')
    .optional()
    .isString()
    .withMessage('Player level filter must be a comma-separated string')
];


export const validateRequestActivity = [
  body('reqFrom')
    .notEmpty().withMessage("Requester ID is required"),
    
  body('reqTo')
    .notEmpty().withMessage("Recipient ID is required"),
    
  body('activityId')
    .notEmpty().withMessage("Activity ID is required")
    .isMongoId().withMessage("Invalid Activity ID format"),
    
  body('activityName')
    .notEmpty().withMessage("Activity name is required")
    .isString().withMessage("Activity name must be a string"),
    
  body('activityLevel')
    .notEmpty().withMessage("Activity level is required")
    .isString().withMessage("Activity level must be a string"),
    
  body('activityDate')
    .notEmpty().withMessage("Activity date is required")
    .matches(/^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[012])-\d{4}$/).withMessage("Invalid date format (DD-MM-YYYY)"),
    
  body('activityTime')
    .notEmpty().withMessage("Activity time is required")
    .matches(/^(1[0-2]|0?[1-9]):[0-5][0-9] (AM|PM)$/i).withMessage("Invalid time format (HH:MM AM/PM)"),
    
  body('note')
    .optional()
    .isString().withMessage("Note must be a string"),
    
  body('video')
    .optional()
    .isString().withMessage("Video must be a base64 string")
    .matches(/^data:video\/\w+;base64,/).withMessage("Invalid video format. Must start with 'data:video/*;base64,'"),

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