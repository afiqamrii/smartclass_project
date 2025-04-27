const authService = require("../services/authService");
const jwt = require("jsonwebtoken");
const User = require("../models/User");


//Sign Up
exports.signUp = async (req, res) => {
    try {
        //Extract data from request
        const { userName, userEmail, name , userPassword , confirmPassword , roleId , externalId } = req.body;

        //Debug
        console.log("Received data:", req.body);

        const result = await authService.signUp({userName, userEmail, name , userPassword, confirmPassword,  roleId , externalId}, res);

        //Send response
        res.status(200).json({ message: "User registered successfully . Please check your email to verify your account", userId: result.userId });

    } catch (err) {
        // Check if the error is user-related
        const userErrors = ["Username or Email is already exists!", "Please Enter Valid Email!", "Passwords do not match!" , "All fields are required!", "An error occurred during verification process!"];
        
        // Handle different types of errors
        //User error - 400
        if (userErrors.includes(err.message)) {
            res.status(400).json({ message: err.message });
        
        //Internal server error - 500
        } else {
            res.status(500).json({ message: "Internal Server Error" });
        }
        console.log(err);
    }
}

//Verify Email
exports.verifyEmail = async (req, res) => {
    const { userId, uniqueString } = req.params;
  
    try {
      const { error, message } = await authService.verifyEmail(userId, uniqueString);
      if (error) {
        res.redirect(`/verified?error=true&message=${message}`);
      } else {
        res.redirect(`/verified?error=false&message=${message}`);
      }
    } catch (err) {
      console.log(err);
      res.redirect(`/verified?error=true&message=Verification failed`);
    }
};

//Sign In
exports.signIn = async (req, res) => {
    try {
        //Extract data from request
        const { userEmail, userPassword } = req.body;
        
        //Debug
        console.log("Received data:", req.body);

        //Call service function with correct parameters
        const result = await authService.signIn(userEmail, userPassword);

        //Send response
        res.status(200).json({ 
            message: "User signed in successfully",
            userId: result.userId,
            userEmail: result.userEmail,
            name: result.name,
            userName: result.userName, 
            externalId: result.externalId,
            roleId: result.roleId,
            token: result.token  // token is included
        });

    } catch (err) {
        // Check if the error is user-related
        const userErrors = ["Invalid Email or Password!","Please Enter Valid Email!","Email is not verified yet! Check your email to verify your account."];
        
        // Handle different types of errors
        //User error - 400
        if(userErrors.includes(err.message)) {
            res.status(400).json({ message: err.message });
        
        //Internal server error - 500
        } else {
            res.status(500).json({ message: "Internal Server Error" });
        }
        console.log(err);
    }
}

//Check Token Validity
exports.checkToken = async (req, res) => {
    try {
        //Check if token is present
        const token = req.headers["x-auth-token"];

        //If token is not present
        if(!token) {
            return res.status(401).json({ message: "No auth token, access denied!" }); //Unauthorized
        }

        //Verify token
        const verified = jwt.verify(token, "passwordKey");

        //If token is not valid
        if(!verified) {
            return res.status(401).json({ message: "Token verification failed, authorization denied!" }); //Unauthorized
        } 

        //Check if user exists
        const user = await User.findOne({ _id: verified.id });

        //If user does not exist
        if(!user) {
            return res.status(401).json({ message: "User not found, authorization denied!" }); //Unauthorized
        }

        //Return true if token is valid
        res.json({ message: "Token is valid", isValid: true });

    } catch (err) {
        if (err.name === "TokenExpiredError") {
            return res.status(401).json({ message: "Token expired, please log in again." });
        }
        res.status(500).json({ message: err.message });
    }
}

//get user data
exports.getUserData = async (req, res) => {
    try {
        const user = await User.findOne({ where: { userId: req.user } });

        if (!user) {
            return res.status(404).json({ message: "User not found!" });
        }

        const userData = { ...user.get({ plain: true }), token: req.token };
        res.json(userData);

        // Print user data
        console.log("User data:", userData);
    } catch (err) {
        console.error("Error retrieving user data:", err);
        res.status(500).json({ message: "Internal Server Error" });
    }
}

//Password Reset Request
exports.requestPasswordReset = async (req, res) => {
    try {
        const { userEmail } = req.body;

        const result = await authService.requestPasswordReset(userEmail);

        // Send consistent JSON response
        res.status(result.status).json(result.json);

    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Internal Server Error" });
    }
};

//Reset Password
exports.resetPassword = async (req, res) => {
    
    try{

        const { userId, resetString , newPassword , confirmPassword} = req.body;

        const result = await authService.resetPassword(userId, resetString, newPassword, confirmPassword );

        // Send consistent JSON response
        res.status(result.status).json(result.json);

        

    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Internal Server Error" });
    }
}

