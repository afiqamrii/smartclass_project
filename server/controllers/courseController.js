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

// Function to get courses assigned to a lecturer
exports.lecturerViewCourses = async (req, res) => {
    try {
        // Log the request for debugging
        console.log("Received request to fetch courses assigned to lecturer");

        //Get from parameter
        const lecturerId = req.params.lecturerId;

        // Validate input
        if (!lecturerId) {
            return res.status(400).json({ message: "Lecturer ID is required" });
        }

        const courses = await courseService.lecturerViewCourses(lecturerId);
        
        res.status(200).json({
            message: "Courses fetched successfully",
            Data: courses ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch courses for lecturer" });
    }
}

// Function to get all courses for students
exports.studentViewCourses = async (req, res) => {
    try {
        // Log the request for debugging
        console.log("Received request to fetch all courses for students");

        //Get from parameter
        const studentId = req.params.studentId;

        const courses = await courseService.studentViewCourses(studentId);
        res.status(200).json({
            message: "Courses fetched successfully",
            Data: courses ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch courses for students" });
    }
}

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

// Function to get all assigned lecturers
exports.getAssignedLecturers = async (req, res) => {
    try {
        //Get from param 
        const courseId = req.params.courseId;
        
        // Validate input
        if (!courseId) {
            return res.status(400).json({ message: "Course ID is required" });
        }

        // Call service to get all assigned lecturers
        const assignedLecturers = await courseService.getAssignedLecturers(courseId);
        
        res.status(200).json({
            message: "Assigned lecturers fetched successfully",
            Data: assignedLecturers ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch assigned lecturers" });
    }
};

//Function to get all lecturers
exports.getLecturers = async (req, res) => {
    try {

        //Debug
        console.log("Received request to fetch all lecturers");
        // Get courseId from params
        const courseId = req.params.courseId;

        //Debug
        if (!courseId) {
            return res.status(400).json({ message: "Course ID is required" });
        }
        console.log("Course ID:", courseId);
        // Call service to get all lecturers
        // This function should return an array of lecturers
        const lecturers = await courseService.getLecturers(courseId);

        res.status(200).json({
            message: "Lecturers fetched successfully",
            Data: lecturers ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch lecturers" });
    }
};

//Function to assign course to lecturer
exports.assignCourse = async (req, res) => {
    try {
        const { courseId, lecturerId , courseName, courseCode, lecturerEmail } = req.body;

        //Debug
        console.log("Received request to assign course to lecturer");
        console.log("Course ID:", courseId);
        console.log("Lecturer ID:", lecturerId);    
        console.log("Course Name:", courseName);
        console.log("Lecturer Email:", lecturerEmail);

        // Validate input
        if (!courseId || !lecturerId) {
            return res.status(400).json({ message: "Course ID and Lecturer ID are required" });
        }

        // Log the received request for debugging
        console.log("Received assign course request:", { courseId, lecturerId });

        const result = await courseService.assignCourse(courseId, lecturerId , courseName, courseCode, lecturerEmail);

        // If success send email notification to lecturer
        if (result) {
            // await emailService.sendAssignmentEmail(lecturerEmail, courseName);
        }
        res.status(200).json({ Status_Code: 200, message: "Course assigned to lecturer successfully", Assigned_Id: result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(400).json({ message: error.message });
    }
}

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