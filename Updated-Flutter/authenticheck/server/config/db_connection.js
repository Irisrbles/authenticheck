import mongoose from "mongoose";
import dotenv from "dotenv";

dotenv.config();

const MONGODB_URI = process.env.DATABASE_URL; 

mongoose.connect(MONGODB_URI)
  .then(() => {
    console.log("Connected to MongoDB!");
  })
  .catch((err) => {
    console.error("MongoDB connection error:", err);
  });