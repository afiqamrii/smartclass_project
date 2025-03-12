const classModel = require("../models/classModel");

// Function to add a class
const addClass = async (classData) => {
    try {
        const classId = await classModel.addClass(classData);
        return { success: true, classId };
    } catch (error) {
        throw new Error("Error in service while adding class: " + error.message);
    }
};

// Function to view class
const viewClass = async () => {
    try {
        const classes = await classModel.getAllClasses();
        return classes;
    } catch (error) {
        throw new Error("Error in service while fetching class data: " + error.message);
    }
};

//EXport module
module.exports = { addClass , viewClass};
