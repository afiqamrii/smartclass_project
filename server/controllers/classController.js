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
    const studentId = req.params.studentId; // Extract studentId from URL parameter
    console.log("Received studentId:", studentId);

    // Validate studentId
    if (!studentId) {
        return res.status(400).json({ message: "Student ID is required" });
    }
    try {
        const todayClasses = await classService.studentViewTodayClass(studentId);
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
    //Get studentId from url
    const studentId = req.params.studentId;

    // Validate studentId
    if (!studentId) {
        return res.status(400).json({ message: "Student ID is required" });
    }

    try {
        const todayClasses = await classService.viewUpcomingClass(studentId);
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
    //Get studentId from url
    const studentId = req.params.studentId;

    // Validate studentId
    if (!studentId) {
        return res.status(400).json({ message: "Student ID is required" });
    }

    try{
        const currentClass = await classService.viewCurrentClass(studentId);
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
     //Get studentId from url
    const studentId = req.params.studentId;

    // Validate studentId
    if (!studentId) {
        return res.status(400).json({ message: "Student ID is required" });
    }

    try{
        const todayClasses = await classService.viewPastClass(studentId);
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

//Function to view current class (LEcturer)
exports.lecturerGetCurrentClass = async (req, res) => {
    try {
        const lecturerId = req.params.lecturerId; // Extract lecturerId from URL parameter

        //Validate lecturerId
        if (!lecturerId) {
            return res.status(400).json({ message: "Lecturer ID is required" });
        }
        
        const currentClass = await classService.lecturerGetCurrentClass(lecturerId);
        res.status(200).json({
            message: "Class data fetched successfully",
            Data: currentClass ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch class data" });
    }
};

//Function to edit classroom
exports.editClassroom = async (req, res) => {
    try {
        console.log("Received update request:", req.body);
        
        const classId = req.params.id; // Extract classId from URL parameter
        const updatedClass = req.body; // Extract request body

        // Call service function with correct parameters
        const result = await classService.editClassroom(classId, updatedClass);

        res.status(200).json({ message: "Classroom data updated successfully", Updated_Id: result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to update classroom data" });
    }
};