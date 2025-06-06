const classModel = require("../models/classModel");
const attendanceService = require("../services/attendanceService");


// Function to add a class
const addClass = async (classData) => {
    try {

        //Fetch image from google API for class based on className or courseName
        // const imageQuery = classData.className ;

        //Fetching images
        // const imageUrl = await fetchImageFromGoogle(imageQuery);

        // //Debug purpose
    // console.log("Image URL:", imageUrl);

        // Ensure we pass correct values in order
        const { courseId , classLocation , timeStart, timeEnd, date  , lecturerId  } = classData;
        
        const classId = await classModel.addClass(courseId , classLocation , timeStart, timeEnd, date  , lecturerId );

        //If class is added successfully, add all students that enroll this course to attendance table
        if (classId) {
            try {
                //Call service to add student attendance
                await attendanceService.addStudentAttendance(classId, courseId);
            } catch (error) {
                console.error("Error in service while adding student attendance: ", error);
            }
        }


        return { success: true, classId };
    } catch (error) {
        throw new Error("Error in service while adding class: " + error.message);
    }
};

// Function to view class
const viewClass = async (lecturerId) => {
    try {
        const classes = await classModel.getAllClasses(lecturerId);
        return classes || [];
    } catch (error) {
        throw new Error("Error in service while fetching class data: " + error.message);
    }
};

const viewClassById = async (classId) => {
    try {
        const classData = await classModel.getClassById(classId);
        return classData || null;
    } catch (error) {
        throw new Error("Error in service while fetching class data: " + error.message);
    }
};

// Function to view class for students
const studentViewTodayClass = async (studentId) => {
    try {
        const todayClasses = await classModel.studentViewTodayClass(studentId);
        return todayClasses || [];
    } catch (error) {
        throw new Error("Error in service while fetching class data: " + error.message);
    }
};

// View past class
const viewPastClass = async (studentId) => {
    try {
        const todayClasses = await classModel.viewPastClass(studentId);
        return todayClasses || [];
    } catch (error) {
        throw new Error("Error in service while fetching class data: " + error.message);
    }
};

// View upcoming class
const viewUpcomingClass = async (studentId) => {
    try {
        const todayClasses = await classModel.viewUpcomingClass(studentId);
        return todayClasses || [];
    } catch (error) {
        throw new Error("Error in service while fetching class data: " + error.message);
    }
};

//View current class
const viewCurrentClass = async (studentId) => {
    try {
        const todayClasses = await classModel.viewCurrentClass(studentId);
        return todayClasses || [];
    } catch (error) {
        throw new Error("Error in service while fetching class data: " + error.message);
    }
}

//Function to update class
const updateClass = async (classId, classData) => {
    try {

        // //Fetch image from google API for class based on className or courseName
        // const imageQuery = classData.className ;

        //Fetching images
        // const imageUrl = await fetchImageFromGoogle(imageQuery);

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

//Function to get current class for lecturer
const lecturerGetCurrentClass = async (lecturerId) => {
    try{
        const result = await classModel.lecturerGetCurrentClass(lecturerId);
        return result;
    } catch(error){
        throw new Error("Error in service while deleting class data: " + error.message);
    }
};

//EXport module
module.exports = { addClass , viewClass ,viewClassById , updateClass , deleteClass , studentViewTodayClass ,viewUpcomingClass ,viewPastClass ,viewCurrentClass ,lecturerGetCurrentClass };
