const classroomService = require("../services/classroomService");

// Function to view all courses
exports.getClassroom = async (req, res) => {
    try {
        const classroom = await classroomService.getClassroom();
        res.status(200).json({
            message: "Classroom data fetched successfully",
            Data: classroom ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch classroom data" });
    }
};
