const classModel = require("../models/classModel");

//Function to fetch image from google API 

const fetchImageFromGoogle= async (query) => {
    try {
        const response = await fetch(`https://www.googleapis.com/customsearch/v1?key=${process.env.GOOGLE_API_KEY}&cx=${process.env.GOOGLE_SEARCH_CX}&q=${query}&searchType=image&imgsz=l&imgar=xw&num=10`);
        const data = await response.json();
        
        //Check to select only if image is landscape or width is greater than height 
        for (const item of data.items) {
            const { width, height } = item.image;

            // Check if image is landscape
            if (width > height) {
                console.log("Image is landscape, returning this image.");
                console.log("Image URL:", item.link);
                return item.link;
            } else {
                console.log("Image is not landscape, skipping this image.");
            }
        }
        //Return default image route if no landscape image is found
        return "https://news.virginia.edu/sites/default/files/Header_Math_Class.jpg";
        
    } catch (error) {
        throw new Error("Error fetching image from Google API: " + error.message);
    }
};
// Function to add a class
const addClass = async (classData) => {
    try {

        //Fetch image from google API for class based on className or courseName
        const imageQuery = classData.className ;

        //Fetching images
        const imageUrl = await fetchImageFromGoogle(imageQuery);

        // //Debug purpose
        // console.log("Image URL:", imageUrl);

        // Ensure we pass correct values in order
        const { courseId , classLocation , timeStart, timeEnd, date  , lecturerId  } = classData;
        
        const classId = await classModel.addClass(courseId , classLocation , timeStart, timeEnd, date  , lecturerId , imageUrl);
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
const studentViewTodayClass = async () => {
    try {
        const todayClasses = await classModel.studentViewTodayClass();
        return todayClasses || [];
    } catch (error) {
        throw new Error("Error in service while fetching class data: " + error.message);
    }
};

// View past class
const viewPastClass = async () => {
    try {
        const todayClasses = await classModel.viewPastClass();
        return todayClasses || [];
    } catch (error) {
        throw new Error("Error in service while fetching class data: " + error.message);
    }
};

// View upcoming class
const viewUpcomingClass = async () => {
    try {
        const todayClasses = await classModel.viewUpcomingClass();
        return todayClasses || [];
    } catch (error) {
        throw new Error("Error in service while fetching class data: " + error.message);
    }
};

//View current class
const viewCurrentClass = async () => {
    try {
        const todayClasses = await classModel.viewCurrentClass();
        return todayClasses || [];
    } catch (error) {
        throw new Error("Error in service while fetching class data: " + error.message);
    }
}

//Function to update class
const updateClass = async (classId, classData) => {
    try {

        //Fetch image from google API for class based on className or courseName
        const imageQuery = classData.className ;

        //Fetching images
        const imageUrl = await fetchImageFromGoogle(imageQuery);

        // Ensure we pass correct values in order
        const { courseCode, className, date, timeStart, timeEnd, classLocation } = classData;
        
        // Call model function with extracted values
        const result = await classModel.updateClass(classId, courseCode, className, date, timeStart, timeEnd, classLocation , imageUrl);
        
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
module.exports = { addClass , viewClass ,viewClassById , updateClass , deleteClass , studentViewTodayClass ,viewUpcomingClass ,viewPastClass ,viewCurrentClass};
