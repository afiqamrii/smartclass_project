const courseModel = require("../models/courseModel");

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

// Function to add a course
const addCourse = async (courseData) => {
    try {
        // Fetch image from Google API for course based on courseName or courseCode
        const imageQuery = courseData.courseName ;
        const imageUrl = await fetchImageFromGoogle(imageQuery);

        // Debug purpose
        console.log("Image URL:", imageUrl);

        // Ensure we pass correct values in order
        const { courseName, courseCode } = courseData;

        const courseId = await courseModel.addCourse(courseName, courseCode, imageUrl);
        return { success: true, courseId };
    } catch (error) {
        throw new Error("Error in service while adding course: " + error.message);
    }
};

// Function to view course
const viewCourse = async () => {
    try {
        const courses = await courseModel.getAllCourses();
        return courses || [];
    } catch (error) {
        throw new Error("Error in service while fetching course data: " + error.message);
    }
};

//Get course by lecturer ID
const getCourseByLecturerId = async (lecturerId) => {
    try {
        // Validate input
        if (!lecturerId) {
            throw new Error("Lecturer ID is required");
        }
        const courses = await courseModel.getCourseByLecturerId(lecturerId);
        return courses || [];
    } catch (error) {
        throw new Error("Error in service while fetching courses for lecturer: " + error.message);
    }
};

//EXport module
module.exports = { viewCourse , addCourse, fetchImageFromGoogle, getCourseByLecturerId };
