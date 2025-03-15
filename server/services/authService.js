const bcrypt = require("bcryptjs");
const User = require("../models/User");
const jwt = require("jsonwebtoken");

//Sign Up
exports.signUp = async (userName , userEmail , userPassword , confirmPassword , roleId) => {

        //Check if all required fields are present
        if(!userName || !userEmail || !userPassword || !confirmPassword || !roleId){
            throw new Error("All fields are required!");
        }

        //Check if password and confirm password match
        if(userPassword !== confirmPassword){
            throw new Error("Passwords do not match!");
        }

        //Check if all required fields are present
        const existingUserEmail = await User.findOne({ where: { userEmail } });
        // if(existingUserEmail){
        //     throw new Error("Email is already exists!");
        // }

        //Check if username already exists
        const existingUsername = await User.findOne({ where : {userName}});
        if(existingUsername || existingUserEmail){
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
            userEmail,
            userPassword: hashedPassword, 
            roleId 
        });

        // Debugging log
        console.log("User created:", user);

        return user;
}

//Sign In
exports.signIn = async (userEmail , userPassword) => {

    //Check if user exists
    const user = await User.findOne({ where : {userEmail}});

    //Check if password is correct
    const isMatch = await bcrypt.compare(userPassword , user.userPassword);

    //Throw error if user email or password is incorrect
    if(!user || !isMatch){
        throw new Error("Invalid Email or Password!");
    }

    //Debugging log
    console.log("User signed in:", user);

    //Token generation and storing it in DB
    const token = jwt.sign({ id: user.userId }, "passwordKey");
    
    console.log("Returning:", { ...user._doc , token });

    return { ...user.get({ plain: true }), token };
}

