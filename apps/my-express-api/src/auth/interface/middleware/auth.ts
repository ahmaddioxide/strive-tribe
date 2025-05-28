//src/auth/interface/middleware/auth.ts
import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import { Config } from "../../../config/config";
import UserModel from "../../infrastructure/models/User";


// Extend Express Request with user property
declare global {
  namespace Express {
    interface Request {
      user?: {
        id: string;
        userId: string;
      };
    }
  }
}

export const authenticate = async (req: Request, res: Response, next: NextFunction) => {
  const token = req.headers.authorization?.split(" ")[1]; // Bearer token
  
  if (!token) {
    return res.status(401).json({ message: "Authorization token required" });
  }

  try {
    // Verify token
    const decoded = jwt.verify(token, process.env.LOBAY_SECRET as string) as { id: string };
    
    // Check if user still exists in database
    const user = await UserModel.findById(decoded.id).select('_id userId');
    
    if (!user) {
      return res.status(401).json({ message: "User no longer exists" });
    }

    // Attach minimal user info to request
    req.user = {
      id: user._id.toString(),
      userId: user.userId
    };

    next();
  } catch (error) {
    return res.status(401).json({ 
      message: "Invalid or expired token",
      ...(process.env.NODE_ENV === 'development' && { error: error.message })
    });
  }
};