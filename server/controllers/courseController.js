const courseService = require("../services/courseService");

// Function to add a course
exports.addCourse = async (req, res) => {
    try {
        // Validate input
        if (!req.body || !req.body.courseName || !req.body.courseCode) {
            return res.status(400).json({ message: "Course name and code are required" });
        }
        // Extract course details from request body
        const addCourse = {
            courseCode: req.body.courseCode,
            courseName: req.body.courseName,
        };
        // Log the received request for debugging
        console.log("Received add course request:", addCourse);

        const result = await courseService.addCourse(addCourse);
        res.status(200).json({ Status_Code: 200, message: "Course added successfully", courseId: result.courseId });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(400).json({ message: error.message });
    }
};

// Function to view all courses
exports.viewCourse = async (req, res) => {
    try {
        const courses = await courseService.viewCourse();
        res.status(200).json({
            message: "Course data fetched successfully",
            Data: courses ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch course data" });
    }
};

// Function to get course by lecturer ID
exports.getCourseByLecturerId = async (req, res) => {
    try {
        const lecturerId = req.params.lecturerId;

        // Validate input
        if (!lecturerId) {
            return res.status(400).json({ message: "Lecturer ID is required" });
        }

        const courses = await courseService.getCourseByLecturerId(lecturerId);
        res.status(200).json({
            message: "Courses fetched successfully",
            Data: courses ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch courses for lecturer" });
    }
};

//Edit courses
exports.editCourse = async (req, res) => {
    try {
        // Validate input
        if (!req.body || !req.params.courseId || !req.body.courseName || !req.body.courseCode) {
            return res.status(400).json({ message: "Course ID, name, and code are required" });
        }
        // Extract course details from request body
        const editCourse = {
            courseId: req.params.courseId,
            courseCode: req.body.courseCode,
            courseName: req.body.courseName,
        };
        // Log the received request for debugging
        console.log("Received edit course request:", editCourse);
        const result = await courseService.editCourse(editCourse);
        res.status(200).json({ Status_Code: 200, message: "Course updated successfully", Updated_Id: result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(400).json({ message: error.message });
    }
};


//Function to soft delete course
exports.softDeleteCourse = async (req, res) => {
    try {
        const courseId = req.params.courseId;
        const result = await courseService.softDeleteCourse(courseId);
        res.status(200).json({ Status_Code: 200, message: "Course deleted successfully", Deleted_Id: result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(400).json({ message: error.message });
    }
};

//Funciton to get deleted course
exports.getDeletedCourse = async (req, res) => {
    try {
        const course = await courseService.getDeletedCourse();
        res.status(200).json({
            message: "Course data fetched successfully",
            Data: course ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch course data" });
    }
};

//Function to restore course
exports.restoreCourse = async (req, res) => {
    try {
        const courseId = req.params.courseId;
        const result = await courseService.restoreCourse(courseId);
        res.status(200).json({ Status_Code: 200, message: "Course restored successfully", Restored_Id: result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(400).json({ message: error.message });
    }
};

//Function to completely delete course
exports.deleteCourse = async (req, res) => {
    try {
        const courseId = req.params.courseId;
        const result = await courseService.deleteCourse(courseId);
        res.status(200).json({ Status_Code: 200, message: "Course deleted successfully", Deleted_Id: result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(400).json({ message: error.message });
    }
};