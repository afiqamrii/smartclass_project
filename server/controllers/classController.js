const classService = require("../services/classService");

// Function to add a class
exports.addClass = async (req, res) => {
    try {
        const addClass = req.body;
        console.log("Received add class request:", addClass);

        const result = await classService.addClass(addClass);
        res.status(200).json({ Status_Code: 200, message: "Class added successfully", classId: result.classId });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(400).json({ message: error.message });
    }
};

//Function to view class
exports.viewClass = async (req,res) => {
    try{
        const classes = await classService.viewClass();
        res.status(200).json({
            message: "Class data fetched successfully", 
            Data: classes ?? [],
        });
    }
    catch(error){
        console.error("Controller Error:", error);
        res.status(500).json({message: "Failed to fetch class data"});
    }
};

exports.studentViewTodayClass = async (req, res) => {
    try {
        const todayClasses = await classService.studentViewTodayClass();
        res.status(200).json({
            message: "Class data fetched successfully",
            Data: todayClasses ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch class data" });
    }
};

//Function to update class
exports.updateClass = async (req, res) => {
    try {
        console.log("Received update request:", req.body);
        
        const classId = req.params.id; // Extract classId from URL parameter
        const updatedClass = req.body; // Extract request body

        // Call service function with correct parameters
        const result = await classService.updateClass(classId, updatedClass);

        res.status(200).json({ message: "Class data updated successfully", Updated_Id: result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to update class data" });
    }
};



//Function to delete class
exports.deleteClass = async (req,res) => {
    try{
        const result = await classService.deleteClass(req.params.id);
        res.status(200).json({message: "Class data deleted successfully", Deleted_Id: result});
    } catch(error){
        console.error("Controller Error:", error);
        res.status(500).json({message: "Failed to delete class data"});
    }
};
