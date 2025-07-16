import mongoose from "mongoose";

// DiplomaHash Schema
const diplomaHashSchema = new mongoose.Schema(
  {
    hash: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      minlength: 32, // Minimum for MD5, adjust based on your hashing algorithm
      maxlength: 128, // Maximum for SHA-512
    },
    algorithm: {
      type: String,
      required: true,
      enum: ["MD5", "SHA-1", "SHA-256", "SHA-512"],
      default: "SHA-256",
      trim: true,
    },
    graduateId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Graduate",
      required: true,
      index: true,
    },
  },
  { timestamps: true }
);

diplomaHashSchema.index({ graduateId: 1, algorithm: 1 });

// Graduate Schema
const graduateSchema = new mongoose.Schema(
  {
    cryptoId: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      minlength: 10,
      maxlength: 50,
    },
    accountType: {
      type: String,
      required: true,
      enum: ["graduate"],
      trim: true,
    },
    fullName: {
      type: String,
      required: true,
      trim: true,
      minlength: 2,
      maxlength: 100,
    },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
      match: [/.+@.+\..+/, "Please enter a valid email address"],
    },
    username: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      minlength: 3,
      maxlength: 30,
      match: [
        /^[a-zA-Z0-9_]+$/,
        "Username must be alphanumeric with underscores",
      ],
    },
    password: {
      type: String,
      required: true,
      minlength: 6,
      maxlength: 128,
    },
    institution: {
      type: String,
      required: true,
      trim: true,
      minlength: 2,
      maxlength: 150,
    },
    courseProgram: {
      type: String,
      required: true,
      trim: true,
      minlength: 2,
      maxlength: 100,
    },
    yearGraduated: {
      type: Number,
      required: true,
      min: 1950,
      max: new Date().getFullYear() + 1,
    },
  },
  { timestamps: true }
);

const DiplomaHash = mongoose.model("DiplomaHash", diplomaHashSchema);
const Graduate = mongoose.model("Graduate", graduateSchema);

export { DiplomaHash, Graduate };

