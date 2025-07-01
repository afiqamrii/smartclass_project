const express = require("express");
const authRouter = express.Router();
const authController = require("../controllers/authController");
const auth = require("../middlewares/auth");
const path = require("path"); 
const app = express();
const multer = require('multer');
const upload = multer({ dest: 'uploads/' });

//Sign Up Route
authRouter.post("/api/signup" , authController.signUp);

//Student sign up route
authRouter.post("/api/studentsignup" ,  upload.single('image') , authController.studentSignUp);

//Verify Email Route
authRouter.get("/verify/:userId/:uniqueString" , authController.verifyEmail);

// Verified page
authRouter.get('/verified', (req, res) => {
    res.sendFile(path.join(__dirname, "../views/verified.html"));
  });

//Sign In Route
authRouter.post("/api/signin/:roleId" , authController.signIn);

//Forget Password Route
authRouter.post("/requestPasswordReset" , authController.requestPasswordReset);

authRouter.post("/resetPassword" , authController.resetPassword);

//Reset Password Redirect to html page to reset password
authRouter.get('/resetPassword/:userId/:resetString', (req, res) => {
  res.sendFile(path.join(__dirname, "../views/resetPassword.html"));
});

//Reset Password Success Page
authRouter.get('/resetSuccess', (req, res) => {
  res.sendFile(path.join(__dirname, "../views/resetSuccess.html"));
});


//Check Token Validity Route
authRouter.post("/tokenIsValid" , authController.checkToken);

//Get User Data Route
authRouter.get("/" , auth , authController.getUserData);

//User update profile details route
authRouter.put("/updateprofile" ,  authController.updateProfile);

//Update profile with image route
authRouter.put("/updateprofileimage" , upload.single('image') , authController.updateProfileImage);


module.exports = authRouter;