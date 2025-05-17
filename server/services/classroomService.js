const classroomModel = require("../models/classroomModel");

// Function to view course
const getClassroom = async () => {
    try {
        const classroom = await classroomModel.getAllClassroom();
        return classroom || [];
    } catch (error) {
        throw new Error("Error in service while fetching classroom data: " + error.message);
    }
};

//EXport module
module.exports = { getClassroom };
