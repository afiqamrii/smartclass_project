const courseService = require("../services/courseService");

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
