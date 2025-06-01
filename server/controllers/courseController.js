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
