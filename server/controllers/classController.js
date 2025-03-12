const classService = require("../services/classService");

// Function to add a class
exports.addClass = async (req, res) => {
    try {
        const result = await classService.addClass(req.body);
        res.status(201).json({ message: "Class added successfully", classId: result.classId });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to add class" });
    }
};

//Function to view class
exports.viewClass = async (req,res) => {
    try{
        const classes = await classService.viewClass();
        res.status(200).json({message: "Class data fetched successfully", data: classes});
    }
    catch(error){
        console.error("Controller Error:", error);
        res.status(500).json({message: "Failed to fetch class data"});
    }
};
