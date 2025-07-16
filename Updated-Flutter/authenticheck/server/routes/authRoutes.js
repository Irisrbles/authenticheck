import express from "express";
import { login, register, forgotPassword, verifyOtp, resetPassword, changePassword } from "../controller/authController.js";

const router = express.Router();

router.post("/login", login);
router.post("/register", register);
router.post("/forgot-password", forgotPassword);
router.post("/verify-otp", verifyOtp);
router.post("/reset-password", resetPassword);
router.post("/change-password", changePassword);

export default router;