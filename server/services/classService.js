const classModel = require("../models/classModel");

// Function to add a class
const addClass = async (classData) => {
    try {

        // Ensure we pass correct values in order
        const { courseCode, className, date, timeStart, timeEnd, classLocation } = classData;
        
        const classId = await classModel.addClass(courseCode, className, date, timeStart, timeEnd, classLocation);
        return { success: true, classId };
    } catch (error) {
        throw new Error("Error in service while adding class: " + error.message);
    }
};

// Function to view class
const viewClass = async () => {
    try {
        const classes = await classModel.getAllClasses();
        return classes || [];
    } catch (error) {
        throw new Error("Error in service while fetching class data: " + error.message);
    }
};

//Function to update class
const updateClass = async (classId, classData) => {
    try {
        // Ensure we pass correct values in order
        const { courseCode, className, date, timeStart, timeEnd, classLocation } = classData;
        
        // Call model function with extracted values
        const result = await classModel.updateClass(classId, courseCode, className, date, timeStart, timeEnd, classLocation);
        
        return result;
    } catch (error) {
        throw new Error("Error in service while updating class data: " + error.message);
    }
};


//Function to delete class
const deleteClass = async (id) => {
    try{
        const result = await classModel.deleteClass(id);
        return result;
    } catch(error){
        throw new Error("Error in service while deleting class data: " + error.message);
    }
};

//EXport module
module.exports = { addClass , viewClass , updateClass , deleteClass };
