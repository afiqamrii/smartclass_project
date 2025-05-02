const courseModel = require("../models/courseModel");

// Function to view course
const viewCourse = async () => {
    try {
        const courses = await courseModel.getAllCourses();
        return courses || [];
    } catch (error) {
        throw new Error("Error in service while fetching course data: " + error.message);
    }
};

//EXport module
module.exports = { viewCourse };
