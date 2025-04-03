import { Request, Response, NextFunction } from "express";
import { body, validationResult } from "express-validator";

export const validateRegister = [
  body("user_id").notEmpty().withMessage("User ID is required"),
  body("email").isEmail().withMessage("Invalid email format"),
  body("name").notEmpty().withMessage("Name is required"),
  body("gender").notEmpty().withMessage("Gender is required"),
  body("date_of_birth").isDate().withMessage("Invalid date format (YYYY-MM-DD)"),
  body("location").notEmpty().withMessage("Location is required"),
  body("phone").notEmpty().withMessage("Phone number is required"),
  body("signInWith")
    .isIn(['google', 'facebook', 'email_password'])
    .withMessage("Invalid sign in method"),
  body("activities").optional().isArray(),
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