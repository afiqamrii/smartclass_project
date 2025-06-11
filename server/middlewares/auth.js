const jwt = require("jsonwebtoken");

const auth = async (req, res, next) => {
    try {
        const token = req.headers["x-auth-token"];

        //Check for token
        if(!token){
            return res.status(401).json({message: "No auth token , access denied !"});
        }

        //Verify token
        const verified = jwt.verify(token, "passwordKey");

        console.log("Verified token:", verified);

        //Show error
        if(!verified){
            return res.status(401).json({message: "Token verification failed , authorization denied !"});
        }

        //User id
        req.user = verified.id;
        req.token = token;

        next(); //Go to next function

    }catch(error){
        res.status(500).json({error : err.message}); 
    }
}

module.exports =  auth ;