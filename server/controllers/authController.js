const authService = require("../services/authService");


//Sign Up
exports.signUp = async (req, res) => {
    try {
        //Extract data from request
        const { userName, userEmail, userPassword , confirmPassword , roleId } = req.body;

        //Debug
        console.log("Received data:", req.body);

        const result = await authService.signUp(userName, userEmail, userPassword, confirmPassword,  roleId);

        //Send response
        res.status(200).json({ message: "User registered successfully", userId: result.userId });

    } catch (err) {
        // Check if the error is user-related
        const userErrors = ["Username or Email is already exists!", "Please Enter Valid Email!", "Passwords do not match!" , "All fields are required!"];
        
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
        res.status(200).json({ message: "User signed in successfully", userId: result.userId });

    } catch (err) {
        // Check if the error is user-related
        const userErrors = ["Invalid Email or Password!"];
        
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
        const token = req.headers("x-auth-token");

        //If token is not present
        if(!token) {
            return res.status(401).json(false); //Unauthorized
        }

        //Verify token
        const verified = jwt.verify(token, "passwordKey");

        //If token is not valid
        if(!verified) {
            return res.status(401).json(false); //Unauthorized
        } 

        //Check if user exists
        const user = await User.findById(verified.id);

        //If user does not exist
        if(!user) {
            return res.status(401).json(false); //Unauthorized
        }

    } catch (err) {
        res.status(500).json({ message: "Internal Server Error" });
        console.log(err);
    }
}

//get user data
exports.getUserData = async (req, res) => {
    
    const user = await User.findById(req.user);

    res.json({...user._doc, token : req.token});
}