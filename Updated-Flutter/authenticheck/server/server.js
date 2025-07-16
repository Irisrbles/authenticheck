import "./config/db_connection.js";
import express from "express";
import cors from "cors";
import authRoutes from "./routes/authRoutes.js";

const app = express();

app.use(cors());
app.use(express.json()); // Add this to parse JSON bodies

app.use("/api", authRoutes); 

app.listen(3000, () => {
    console.log("Server is running on port 3000");
});