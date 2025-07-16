import { Graduate } from "../model/authenticheck.js";
import bcrypt from "bcryptjs";
import nodemailer from "nodemailer";

// In-memory OTP store: { email: { otp, expires, verified } }
const otpStore = {};

export const login = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await Graduate.findOne({ email });
    if (!user) {
    console.log("Invalid email or password");
      return res.status(401).json({ message: "Invalid email or password" });
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
        console.log("Invalid email or password");
      return res.status(401).json({ message: "Invalid email or password" });
    }
    res.json({
      message: "Login successful",
      user: {
        username: user.username,
        fullName: user.fullName,
        email: user.email,
        institution: user.institution,
        courseProgram: user.courseProgram,
        yearGraduated: user.yearGraduated
      }
    });
  } catch (err) {
    res.status(500).json({ message: "Server error", error: err.message });
  }
};

export const register = async (req, res) => {
  const { fullName, school, course, yearGraduated, email, diploma, password } = req.body;
  if (!fullName || !school || !course || !yearGraduated || !email || !diploma || !password) {
    return res.status(400).json({ message: "All fields are required." });
  }
  try {
    // Check for duplicate email
    const existing = await Graduate.findOne({ email });
    if (existing) {
     console.log("Email already registered.");
      return res.status(409).json({ message: "Email already registered." });
    }
    // Generate a username for now (or accept from req.body if you want)
    const username = email.split('@')[0] + Math.floor(Math.random() * 10000);
    const hashedPassword = await bcrypt.hash(password, 10);
    const newGraduate = new Graduate({
      cryptoId: Date.now().toString(),
      accountType: "graduate",
      fullName,
      email,
      username,
      password: hashedPassword,
      institution: school,
      courseProgram: course,
      yearGraduated,
    });
    await newGraduate.save();
    // For now, just return the graduate info (not diploma handling)
    console.log("Registration successful");
    res.status(201).json({
      message: "Registration successful",
      user: {
        username: newGraduate.username,
        fullName: newGraduate.fullName,
        email: newGraduate.email,
        institution: newGraduate.institution,
        courseProgram: newGraduate.courseProgram,
        yearGraduated: newGraduate.yearGraduated
      }
    });
  } catch (err) {
    res.status(500).json({ message: "Server error", error: err.message });
  }
};

export const forgotPassword = async (req, res) => {
  const { email } = req.body;
  if (!email) return res.status(400).json({ message: "Email is required" });
  try {
    const user = await Graduate.findOne({ email });
    if (!user) return res.status(404).json({ message: "No user found with that email" });
    // Generate 4-digit OTP
    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    otpStore[email] = {
      otp,
      expires: Date.now() + 10 * 60 * 1000, // 10 minutes
      verified: false
    };
    // Send OTP via email
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: 'authenticheck19@gmail.com', // replace with your email
        pass: 'ukes muen qqkz vytp' // replace with your app password
      }
    });
    await transporter.sendMail({
      from: 'authenticheck19@gmail.com',
      to: email,
      subject: 'Your OTP Code',
      text: `Your OTP code is: ${otp}`
    });
    res.json({ message: "OTP sent to your email" });
  } catch (err) {
    console.error('Nodemailer error:', err);
    res.status(500).json({ message: "Server error", error: err.message });
  }
};

export const verifyOtp = (req, res) => {
  const { email, otp } = req.body;
  if (!email || !otp) return res.status(400).json({ message: "Email and OTP are required" });
  const record = otpStore[email];
  if (!record) return res.status(400).json({ message: "No OTP requested for this email" });
  if (Date.now() > record.expires) return res.status(400).json({ message: "OTP expired" });
  if (String(record.otp).trim() !== String(otp).trim()) {
    console.log('Expected OTP:', record.otp, 'User input:', otp);
    return res.status(400).json({ message: "Invalid OTP" });
  }
  otpStore[email].verified = true;
  res.json({ message: "OTP verified" });
};

export const resetPassword = async (req, res) => {
  const { email, newPassword } = req.body;
  if (!email || !newPassword) return res.status(400).json({ message: "Email and new password are required" });
  const record = otpStore[email];
  if (!record || !record.verified) return res.status(400).json({ message: "OTP not verified for this email" });
  try {
    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await Graduate.findOneAndUpdate({ email }, { password: hashedPassword });
    delete otpStore[email];
    res.json({ message: "Password reset successful" });
  } catch (err) {
    res.status(500).json({ message: "Server error", error: err.message });
  }
};

export const changePassword = async (req, res) => {
  const { email, currentPassword, newPassword } = req.body;
  if (!email || !currentPassword || !newPassword) {
    return res.status(400).json({ message: "All fields are required." });
  }
  try {
    const user = await Graduate.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found." });
    }
    const isMatch = await bcrypt.compare(currentPassword, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: "Current password is incorrect." });
    }
    const hashedPassword = await bcrypt.hash(newPassword, 10);
    user.password = hashedPassword;
    await user.save();
    res.json({ message: "Password changed successfully." });
  } catch (err) {
    res.status(500).json({ message: "Server error", error: err.message });
  }
};