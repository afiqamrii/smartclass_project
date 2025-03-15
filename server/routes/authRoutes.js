const express = require("express");
const authRouter = express.Router();
const authController = require("../controllers/authController");
const auth = require("../middlewares/auth");

//Sign Up Route
authRouter.post("/api/signup" , authController.signUp);

//Sign In Route
authRouter.post("/api/signin" , authController.signIn);

//Check Token Validity Route
authRouter.post("/tokenIsValid" , authController.checkToken);

//Get User Data Route
authRouter.get("/" , auth , authController.getUserData);


    

module.exports = authRouter;