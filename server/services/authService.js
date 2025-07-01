const bcrypt = require("bcryptjs");
const User = require("../models/User");
const jwt = require("jsonwebtoken");

const UserVerification = require("../models/UserVerification");
const PasswordReset = require("../models/PasswordReset");
const { Op } = require('sequelize');

const { Storage } = require('@google-cloud/storage');
const reportModel = require('../models/reportModel');
const axios = require('axios');
const FormData = require('form-data');
const { GoogleAuth } = require('google-auth-library');
require("dotenv").config();
const path = require('path');
const fs = require('fs');

let credentials;
let auth;

// Initialize GoogleAuth with credentials from environment variable (same as gcsTokenRoute.js)
if (process.env.GOOGLE_APPLICATION_CREDENTIALS_JSON) {
  credentials = JSON.parse(process.env.GOOGLE_APPLICATION_CREDENTIALS_JSON);

  // Fix formatting of private_key by replacing escaped newlines
  if (credentials.private_key) {
    credentials.private_key = credentials.private_key.replace(/\\n/g, '\n');
  }

  auth = new GoogleAuth({
    scopes: ['https://www.googleapis.com/auth/devstorage.read_write'],
  });

  // Load the credentials into the auth instance
  (async () => {
    try {
      await auth.fromJSON(credentials);
    } catch (error) {
      console.error("Failed to initialize GoogleAuth with provided credentials:", error);
    }
  })();
} else {
  console.error("GOOGLE_APPLICATION_CREDENTIALS_JSON environment variable is missing.");
}

async function getBearerToken() {
  try {
    if (!auth) throw new Error('GoogleAuth is not initialized.');
    const client = await auth.getClient();
    const accessTokenResponse = await client.getAccessToken();

    if (!accessTokenResponse || !accessTokenResponse.token) {
      throw new Error('Failed to get access token');
    }
    return accessTokenResponse.token;
  } catch (error) {
    console.error('Error fetching access token:', error);
    throw error;
  }
}

exports.uploadImageToGCS = async (imageFile) => {
  try {
    const accessToken = await getBearerToken();

    const gcsFileName = `usersImages/${Date.now()}_${imageFile.originalname}`;
    const uploadUrl = `${process.env.gcsStorageUrl}/${process.env.bucketName}/o?uploadType=multipart&name=${encodeURIComponent(gcsFileName)}`;

    const form = new FormData();
    form.append('metadata', JSON.stringify({
      name: gcsFileName,
      contentType: imageFile.mimetype,
    }), {
      contentType: 'application/json',
    });
    const fileBuffer = fs.readFileSync(imageFile.path);
    form.append('media', fileBuffer, {
    filename: imageFile.originalname,
    contentType: imageFile.mimetype,
    });

    const response = await axios.post(uploadUrl, form, {
      headers: {
        ...form.getHeaders(),
        Authorization: `Bearer ${accessToken}`,
      },
    });

    const imageUrl = `https://storage.googleapis.com/${process.env.bucketName}/${gcsFileName}`;
    return imageUrl;
  } catch (error) {
    console.error('Error uploading image to GCS:', error.response?.data || error.message);
    throw new Error('Failed to upload image');
  }
};


//Email handler
const nodemailer = require("nodemailer");

//Unique string
const {v4: uuidv4} = require("uuid");
const { reset } = require("nodemon");

//Env var
require("dotenv").config();

//nodemailer stuff
let transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
        user: process.env.AUTH_EMAIL,
        pass: process.env.AUTH_PASSWORD
    }
})

//Testing success
transporter.verify(function(error, success) {
    if (error) {
        console.log(error);
    } else {
        console.log("Server is ready to take our messages");
        console.log(success);
    }
})

//Sign Up
exports.signUp = async ({userName , userEmail , name , userPassword , confirmPassword , roleId , externalId}, res) => {

        console.log("Received data:", {userName , userEmail , name , userPassword , confirmPassword , roleId , externalId}); //Debugging Purposes

        //Check if all required fields are present
        if(!userName || !userEmail || !name || !userPassword || !confirmPassword || !roleId || !externalId){
            throw new Error("All fields are required!");
        }

        //Check if password and confirm password match
        if(userPassword !== confirmPassword){
            throw new Error("Passwords do not match!");
        }

        //Check if all required fields are present
        const existingUserEmail = await User.findOne({ where: { userEmail } });

        //Check if username already exists
        const existingUsername = await User.findOne({ where : {userName}});

        //Check if externalId already exists
        const existingExternalId = await User.findOne({ where : {externalId}});

        if(existingUsername || existingUserEmail || existingExternalId){
            console.log(existingUserEmail , existingUsername);
            throw new Error("Username or Email is already exists!");
        }

        //Validate email format
        const emailRegex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$/i;
        if (!emailRegex.test(userEmail)) {
            throw new Error("Please Enter Valid Email!");
        }

        //Hash the password
        const hashedPassword = await bcrypt.hash(userPassword, 8);
        
        // ✅ Create and return new user
        const user = await User.create({ 
            userName, 
            name,
            userEmail,
            userPassword: hashedPassword, 
            roleId,
            verified: false,
            is_approved: "Pending",
            externalId: externalId
        });

        //Send verification email

        //extract user id and email to send verification email
        result = {userId: user.userId, userEmail: user.userEmail};

        //Send verification email
        sendVerificationEmail(result,res);

        //Send response
        console.log("Sending Verification Email to:", user.userEmail);

        // Debugging log
        console.log("User created:", user);

        return user;
}

//Send verification email
const sendVerificationEmail = async ({userId, userEmail} , res) => {
    //Url to be sent in email
    const url = process.env.BASE_URL;

    //Generate unique string
    const uniqueString = uuidv4() + userId;

    //Mail option
    const mailOptions = {
        from: process.env.AUTH_EMAIL,
        to: userEmail,
        subject: "Verify Your Email - IntelliClass",
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;">

            <!-- Logo Section -->
            <div style="text-align: center; margin-bottom: 20px;">
                <img src="https://i.imgur.com/LndAkqq.png
                " alt="IntelliClass Logo" style="max-width: 150px; height: auto;">
            </div>

            <!-- Welcome Heading -->
            <h2 style="color: #4CAF50; text-align: center;">Welcome to IntelliClass!</h2>

            <!-- Body Content -->
            <p style="font-size: 16px; color: #333;">Hi there,</p>
            <p style="font-size: 16px; color: #333;">Thank you for signing up! Please verify your email address to activate your account.</p>
            
            <!-- Verify Button -->
            <div style="text-align: center; margin: 30px 0;">
                <a href="${url}/verify/${userId}/${uniqueString}" 
                style="background-color: #4CAF50; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-size: 16px;">
                Verify Email
                </a>
            </div>
            
            <!-- Additional Info -->
            <p style="font-size: 14px; color: #555;">This verification link will expire in <strong>6 hours</strong>.</p>
            <p style="font-size: 14px; color: #555;">If you did not request this, please ignore this email.</p>
            
            <!-- Footer -->
            <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
            <p style="font-size: 12px; color: #999; text-align: center;">&copy; ${new Date().getFullYear()} IntelliClass. All rights reserved.</p>
            </div>
        `
    };

    //hash the uniqueString
    const saltRound = 10;

    try {
        //Hash the uniqueString
        const hashedUniqueString = await bcrypt.hash(uniqueString, saltRound);
        
        //Save UserVerification
        await UserVerification.create({
            userId,
            uniqueString: hashedUniqueString,
            createdAt: new Date(),
            expiresAt: new Date(Date.now() + 21600000)
        });

        //Debug
        console.log("UserVerification created successfully!");
        console.log("Verification email sent successfully!");
        
        //Send email
        await transporter.sendMail(mailOptions);
    
    //Catch error
    } catch (err) {
        console.log(err);
        console.log(err);
        // Throw error back to service/controller
        throw new Error("An error occurred during verification process!");
    }
}    

//Verify Email
exports.verifyEmail = async (userId, uniqueString) => {
    try {
        const userVerification = await UserVerification.findOne({ where: { userId } });
        if (!userVerification) {
            return { error: true, message: "No verification record found!" };
        }
    
        // Check if expired
        if (userVerification.expiresAt < Date.now()) {
            await UserVerification.destroy({ where: { userId } });
            return { error: true, message: "Verification link has expired." };
        }
    
        // Compare hashed unique string
        const match = await bcrypt.compare(uniqueString, userVerification.uniqueString);
        if (!match) {
            return { error: true, message: "Invalid verification details." };
        }

        // Update user's verified status
        await User.update({ verified: true }, { where: { userId: userId } });
        await UserVerification.destroy({ where: { userId } });

        // Fetch the verified user's details
        const verifiedUser = await User.findOne({ where: { userId } });
        if (!verifiedUser) {
            return { error: true, message: "Verified user not found." };
        }

        // Send notification email to superadmin
        const superadminEmail = process.env.SUPERADMIN_EMAIL; 

        const mailOptions = {
            from: process.env.AUTH_EMAIL,
            to: superadminEmail,
            subject: "New User Email Verified - Pending Your Approval",
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;">
                    <div style="text-align: center; margin-bottom: 20px;">
                        <img src="https://i.imgur.com/LndAkqq.png" alt="IntelliClass Logo" style="max-width: 150px;">
                    </div>
                    <h2 style="color: #FF9800; text-align: center;">New User Verified</h2>
                    <p style="font-size: 16px; color: #333;">A new user has verified their email and is now pending admin approval. Here are the user details:</p>
                    <ul style="font-size: 15px; color: #333; line-height: 1.6;">
                        <li><strong>Name:</strong> ${verifiedUser.name}</li>
                    </ul>
                    <p style="font-size: 14px; color: #555;">Please login to the admin dashboard to review and approve the user account.</p>
                    <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
                    <p style="font-size: 12px; color: #999; text-align: center;">&copy; ${new Date().getFullYear()} IntelliClass. All rights reserved.</p>
                </div>
            `
        };

        // Send the email (assuming you're using nodemailer)
        await transporter.sendMail(mailOptions);

        return { 
            error: false, 
            message: "Email has been successfully verified! Now wait for admin approval. We will notify you once approved." 
        };
    } catch (err) {
        console.log(err);
        return { error: true, message: "Error occurred during verification." };
    }
};


//Sign In
exports.signIn = async (userEmail , userPassword) => {

    //Validate email format
    const emailRegex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$/i;
    if (!emailRegex.test(userEmail)) {
        throw new Error("Please Enter Valid Email!");
    }

    //Check if user exists
    const user = await User.findOne({ where : {userEmail}});

    //Throw error if user does not exist
    if(!user){
        throw new Error("Invalid Email or Password!");
    }

    // Check email verification
    if (!user.verified) {
        throw new Error("Email is not verified yet! Check your email to verify your account.");
    }

    //Check if user is approved by admin or not
    if (user.is_approved == "Pending") {
        throw new Error("Your account is not approved by admin yet! Please wait for approval.");
    }

    //Check if user account is disabled or not
    if (user.is_approved == "Disabled") {
        throw new Error("Your account has been disabled by admin! Please try again later.");
    }


    //Check if password is correct
    const isMatch = await bcrypt.compare(userPassword , user.userPassword);

    //Throw error if password is incorrect
    if(!isMatch){
        throw new Error("Invalid Email or Password!");
    }

    //Debugging log
    console.log("User signed in:", user);

    //Token generation and storing it in DB
    const token = jwt.sign(
    {
        id: user.userId,
        role: user.roleId === 5 ? "superadmin" : "user" 
    },
        "passwordKey",
        { expiresIn: "24h" }
    );

    console.log("user.roleId:", user.roleId);  // Check if it is 5
    console.log("role:", user.roleId === 5 ? "superadmin" : "user");  // Expected: "superadmin"

    const decoded = jwt.decode(token);
    console.log("Decoded token:", decoded);  // It MUST include "role": "superadmin"


    
    console.log("Returning:", { ...user.get({ plain: true }) , token });
12
    return { ...user.get({ plain: true }), token };
}

//Reset Password Request
exports.requestPasswordReset = async (userEmail) => {
    try {
        console.log("Received data:", { userEmail });

        //Check if form is has value or not
        if (userEmail === "") {
            return { status: 400, json: { message: "The email field is required." } };
        }

        //Validate email format
        const emailRegex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$/i;
        if (!emailRegex.test(userEmail)) {
            return { status: 400, json: { message: "Please Enter Valid Email!" } };
        }

        // Check if user exists
        const user = await User.findOne({ where: { userEmail } });

        if (!user) {
            return { status: 400, json: { message: "User does not exist." } };
        }

        // Check if user is verified
        if (!user.verified) {
            return { status: 400, json: { message: "Email is not verified yet! Check your email to verify your account." } };
        }

        // Proceed with email to reset password
        const emailResult = await sendResetEmail(user.userId, user.userEmail);

        if (emailResult.success) {
            return { status: 200, json: { message: emailResult.message } };
        } else {
            return { status: 500, json: { message: "Failed to send password reset email." } };
        }

    } catch (err) {
        console.error("Error in requestPasswordReset:", err.message);
        return { status: 500, json: { message: "Internal Server Error" } };
    }
};

//send password reset email
const sendResetEmail = async (userId, userEmail) => {

    // //Redirect url to reset password
    // const redirectUrl = `http://172.20.10.2:3000`;

    //Url wifi rumah
    const redirectUrl = process.env.BASE_URL;

    try {
        const resetString = uuidv4() + userId;

        // Clear existing records
        await PasswordReset.destroy({ where: { userId } });

        // Hash reset string
        const hashedUniqueString = await bcrypt.hash(resetString, 10);

        // Save reset record
        await PasswordReset.create({
            userId,
            uniqueString: hashedUniqueString,
            createdAt: new Date(),
            expiresAt: new Date(Date.now() + 3600000),
        });

        // Email options
        const mailOptions = {
            from: process.env.AUTH_EMAIL,
            to: userEmail,
            subject: "Reset Your Password - IntelliClass",
            html: `<div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;">
            <div style="text-align: center; margin-bottom: 20px;">
               <img src="https://res.cloudinary.com/dw0bht7lt/image/upload/v1742396515/logo_miwem8.png" 
            alt="IntelliClass Logo" style="max-width: 150px; height: auto;">
            </div>
            <h2 style="color: #4CAF50; text-align: center;">Reset Your Password</h2>
            <p style="font-size: 16px; color: #333;">Hi there,</p>
            <p style="font-size: 16px; color: #333;">We received a request to reset your password for your IntelliClass account.</p>
            <p style="font-size: 16px; color: #333;">Click the button below to reset your password:</p>
            <div style="text-align: center; margin: 30px 0;">
                <a href="${redirectUrl}/resetPassword/${userId}/${resetString}" 
                style="background-color: #4CAF50; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-size: 16px;">
                Reset Password
                </a>
            </div>
            <p style="font-size: 14px; color: #555;">This password reset link will expire in <strong>1 hour</strong>.</p>
            <p style="font-size: 14px; color: #555;">If you did not request this, you can safely ignore this email.</p>
            <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
            <p style="font-size: 12px; color: #999; text-align: center;">&copy; ${new Date().getFullYear()} IntelliClass. All rights reserved.</p>
        </div>`
        };

        const emailResult = await transporter.sendMail(mailOptions);

        if (emailResult.accepted.length === 0) {
            return { success: false };
        }

        console.log("Password reset email sent successfully!");
        return {
            success: true,
            message: "Password reset link sent successfully. Please check your email."
        };

    } catch (err) {
        console.error("Error in sendResetEmail:", err.message);
        return { success: false };
    }
};

//Reset password
exports.resetPassword = async (userId, resetString, newPassword, confirmPassword) => {
    try{

        //Check if all required fields are present
        if(!newPassword || !confirmPassword){
            throw new Error("All fields are required!");
        }

        //Check if passwords match
        if(newPassword !== confirmPassword){
            throw new Error("Passwords do not match!");
        }

        //Check is there any password reset record request
        const passwordResetRecord = await PasswordReset.findOne({ where: { userId } });

        if(passwordResetRecord === null){
            return { status: 400, json: { message: "Password reset record not found!" } };
        } else{

            //Debug
            console.log("Password reset record found:", passwordResetRecord);
            
            //If password reset record is found
            // Check if expired
            if (passwordResetRecord.expiresAt < new Date()) {
                return { status: 400, json: { message: "Password reset link has expired!" } };
            }

            // Verify reset string
            const isVerified = await bcrypt.compare(resetString, passwordResetRecord.uniqueString);

            if (!isVerified) {
                return { status: 400, json: { message: "Invalid password reset link!" } };
            }

            const saltRound = 10;

            // Hash new password
            const hashedPassword = await bcrypt.hash(newPassword, saltRound);

            // Update password
            await User.update({ userPassword: hashedPassword }, { where: { userId } });

            // Delete password reset record
            await PasswordReset.destroy({ where: { userId } });

        }

        console.log("Password reset successfully!");
        return {
            status: 200,
            json: {
                success: true,
                message: "Password reset successfully. You can now sign in with your new password."
            }
        };
        

    } catch(err){

        //Return error
        console.error("Error in resetPassword:", err.message);
        return { status: 500, json: { message: "Internal Server Error" } };
    }
};

exports.updateProfile = async (userId, userName, name) => {
    // Check if username is already in use by another user (not this user)
    const existingUserName = await User.findOne({ 
        where: { 
            userName,
            userId: { [Op.ne]: userId } // username exists but belongs to different user
        }
    });

    if(existingUserName){
        throw new Error("Username is already in use!");
    }

    // Update user profile
    await User.update({ userName, name }, { where: { userId } });

    console.log("Profile updated successfully!");
    return {
        status: 200,
        json: {
            success: true,
            message: "Profile updated successfully."
        }
    };
};

exports.updateProfileImage = async (userId, userName, name, user_picture_url) => {
    // Update user profile image
    // Check if username is already in use by another user (not this user)
    const existingUserName = await User.findOne({ 
        where: { 
            userName,
            userId: { [Op.ne]: userId } // username exists but belongs to different user
        }
    });

    if(existingUserName){
        throw new Error("Username is already in use!");
    }

    // Update user profile
    await User.update({ userName, name , user_picture_url  }, { where: { userId } });

    console.log("Profile updated successfully!");
    return {
        status: 200,
        json: {
            success: true,
            message: "Profile updated successfully."
        }
    };
};      



