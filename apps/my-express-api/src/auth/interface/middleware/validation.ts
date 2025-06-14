import e, { Request, Response, NextFunction } from "express";
import { body, validationResult, query, param } from "express-validator";

export const validateRegister = [
  body("user_id").notEmpty().withMessage("User ID is required"),
  body("email").isEmail().withMessage("Invalid email format"),
  body("name").notEmpty().withMessage("Name is required"),
  body("gender").notEmpty().withMessage("Gender is required"),
  body("dateOfBirth").notEmpty().withMessage("Invalid date format (YYYY-MM-DD)"),
  body("postalCode").notEmpty().withMessage("Postal code is required").matches(/^\d{5}(-\d{4})?$/).withMessage("Invalid US postal code format"),
  body("phone").notEmpty().withMessage("Phone number is required"),
  body("signInWith")
    .isIn(['google', 'facebook', 'email_password'])
    .withMessage("Invalid sign in method"),
  body("isVarified").optional().isBoolean().withMessage("isVarified must be a boolean"),
  body("activities").optional().isArray(),
  body("profile_image")
    .optional()
    .isString().withMessage("Profile image must be a base64 string")
    .custom((value) => {
      if (!value.startsWith('data:image/')) {
        throw new Error('Invalid image format. Must start with data:image/');
      }
      
      // Check base64 size before processing
      const base64Data = value.replace(/^data:image\/\w+;base64,/, '');
      const buffer = Buffer.from(base64Data, 'base64');
      if (buffer.length > 100 * 1024 * 1024) {
        throw new Error('Profile image size exceeds 100MB limit');
      }
      
      return true;
    }),
  (req: Request, res: Response, next: NextFunction) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  }
];

export const validateLogin = [
  body("user_id")
    .notEmpty().withMessage("user_id is required")
    .isString().withMessage("user_id must be a string"),
  (req: Request, res: Response, next: NextFunction) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  }
];


export const validateUpdate = [
  body("user_id")
    .notEmpty().withMessage("user_id is required")
    .isString().withMessage("user_id must be a string"),

  body("name")
    .optional()
    .notEmpty().withMessage("Name cannot be empty")
    .isString().withMessage("Name must be a string"),

  body("email")
    .optional()
    .isEmail().withMessage("Invalid email format"),

  body("postalCode")
    .optional()
    .notEmpty().withMessage("postal Code cannot be empty")
    .isString().withMessage("Postal Code must be a string"),

  body("phone")
    .optional()
    .notEmpty().withMessage("Phone number cannot be empty")
    .isMobilePhone("any").withMessage("Invalid phone number format"),

  body("dateOfBirth")
    .optional()
    .matches(/^\d{4}-\d{2}-\d{2}$/).withMessage("Invalid date format (YYYY-MM-DD)")
    .custom((value) => {
      const date = new Date(value);
      if (isNaN(date.getTime())) {
        throw new Error("Invalid date of birth");
      }
      return true;
    }),

  body("gender")
    .optional()
    .notEmpty().withMessage("Gender cannot be empty")
    .isString().withMessage("Gender must be a string"),

  body("activities")
    .optional()
    .isArray().withMessage("Activities must be an array"),

  body("profile_image")
    .optional()
    .isString().withMessage("Profile image must be a base64 string")
    .custom((value) => {
      if (!value.startsWith('data:image/')) {
        throw new Error('Invalid image format. Must start with data:image/');
      }
      return true;
    }),

  body("isVarified")
    .optional()
    .isBoolean().withMessage("isVarified must be a boolean"),

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

// Add to validation.ts
export const validateCheckUser = [
  query("user_id")
    .notEmpty().withMessage("user_id is required")
    .isString().withMessage("user_id must be a string"),
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

export const validateGetUser = [
  query("userId")
    .notEmpty().withMessage("userId is required")
    .isString().withMessage("userId must be a string"),
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
  
export const validateGetUserById = [
  query("requesterId").notEmpty().withMessage("requesterId is required"),
  query("activityId").notEmpty().withMessage("userId is required"),
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
]

export const validateNearPlayerByUserById = [
  param("userId").notEmpty().withMessage("userId is required"),
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
]

export const validateCommonActivities = [
  query("reqFrom")
    .notEmpty().withMessage("reqFrom is required")
    .isString().withMessage("reqFrom must be a string"),

  query("reqTo")
    .notEmpty().withMessage("reqTo is required")
    .isString().withMessage("reqTo must be a string"),

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


export const validateGetActivities = [
  query("userId")
    .notEmpty().withMessage("User ID is required")
    .isString().withMessage("User ID must be a string")
    .trim(),
    
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

export const validateReportProblem = [
  body("name")
    .trim()
    .notEmpty().withMessage("Name is required")
    .isLength({ min: 3, max: 50 }).withMessage("Name must be 2-50 characters"),

  body("email")
    .trim()
    .notEmpty().withMessage("Email is required")
    .isEmail().withMessage("Invalid email format")
    .normalizeEmail(),
    
  body("description")
    .trim()
    .notEmpty().withMessage("Description is required")
    .isLength({ min: 5, max: 2000 }).withMessage("Description must be 5-1000 characters"),
    
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