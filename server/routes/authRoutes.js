const express = require("express");
const authRouter = express.Router();
const authController = require("../controllers/authController");
const auth = require("../middlewares/auth");
const path = require("path"); 
const app = express();

//Sign Up Route
authRouter.post("/api/signup" , authController.signUp);

//Verify Email Route
authRouter.get("/verify/:userId/:uniqueString" , authController.verifyEmail);

// Verified page
authRouter.get('/verified', (req, res) => {
    res.sendFile(path.join(__dirname, "../views/verified.html"));
  });

//Sign In Route
authRouter.post("/api/signin" , authController.signIn);

//Check Token Validity Route
authRouter.post("/tokenIsValid" , authController.checkToken);

//Get User Data Route
authRouter.get("/" , auth , authController.getUserData);


module.exports = authRouter;