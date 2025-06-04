const classService = require("../services/classService");

// Function to add a class
exports.addClass = async (req, res) => {
    try {
        const addClass = req.body;
        console.log("Received add class request:", addClass);

        //Filter time to add understandable format
        if (addClass.startTime && addClass.endTime) {
            addClass.startTime = new Date(addClass.startTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            addClass.endTime = new Date(addClass.endTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        } else {
            addClass.startTime = null;
            addClass.endTime = null;
        }

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
        const lecturerId = req.params.lecturerId;
        const classes = await classService.viewClass(lecturerId);
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

exports.viewClassById = async (req, res) => {
    try {
        const classId = req.params.id;
        const classData = await classService.viewClassById(classId);
        res.status(200).json({
            message: "Class data fetched successfully",
            Data: classData ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch class data" });
    }
}

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

//Student view upcoming class
exports.viewUpcomingClass = async (req, res) => {
    try {
        const todayClasses = await classService.viewUpcomingClass();
        res.status(200).json({
            message: "Class data fetched successfully",
            Data: todayClasses ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch class data" });
    }
}

//View current class
exports.viewCurrentClass = async (req,res) =>{
    try{
        const currentClass = await classService.viewCurrentClass();
        res.status(200).json({
            message: "Class data fetched successfully",
            Data: currentClass ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch class data" });
    }
}

//View passt class
exports.viewPastClass = async (req,res) =>{
    try{
        const todayClasses = await classService.viewPastClass();
        res.status(200).json({
            message: "Class data fetched successfully",
            Data: todayClasses ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch class data" });
    }
}

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
