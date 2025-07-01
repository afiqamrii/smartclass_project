const courseModel = require("../models/courseModel");

const nodemailer = require("nodemailer");

//nodemailer stuff
let transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
        user: process.env.AUTH_EMAIL,
        pass: process.env.AUTH_PASSWORD
    }
})

// //Testing success
// transporter.verify(function(error, success) {
//     if (error) {
//         console.log(error);
//     } else {
//         console.log("Server is ready to take our messages");
//         console.log(success);
//     }
// })

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
        throw new Error( error.message);
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

// Function to get courses assigned to a lecturer
const lecturerViewCourses = async (lecturerId) => {
    try {
        const courses = await courseModel.lecturerViewCourses(lecturerId);
        return courses || [];
    } catch (error) {
        throw new Error("Error in service while fetching courses for lecturer: " + error.message);
    }
};

// Function to get all courses for students
const studentViewCourses = async (studentId) => {
    try {

        // Validate input
        if (!studentId) {
            throw new Error("Student ID is required");
        }

        const courses = await courseModel.studentViewCourses(studentId);
        return courses || [];
    } catch (error) {
        throw new Error("Error in service while fetching courses for students: " + error.message);
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

//Edit course
const editCourse = async (editCourse) => {
    try {
        const result = await courseModel.editCourse(editCourse);
        return result;
    } catch (error) {
        throw new Error("Error in service while editing course: " + error.message);
    }
};

//Function to get all assigned lecturers
const getAssignedLecturers = async (courseId) => {
    try {
        const assignedLecturers = await courseModel.getAssignedLecturers(courseId);
        return assignedLecturers || [];
    } catch (error) {
        throw new Error("Error in service while fetching assigned lecturers: " + error.message);
    }
};

//Function to get all lecturers
const getLecturers = async (courseId) => {
    try {
        const lecturers = await courseModel.getLecturers(courseId);
        return lecturers || [];
    } catch (error) {
        throw new Error("Error in service while fetching lecturers: " + error.message);
    }
};

//Function to assign course to lecturer
const assignCourse = async (courseId, lecturerId , courseName, courseCode, lecturerEmail) => {
    try {
        // Validate input
        if (!courseId || !lecturerId) {
            throw new Error("Course ID and Lecturer ID are required");
        }
        // Log the received request for debugging
        console.log("Assigning course:", { courseId, lecturerId });

        // Call the model function to assign course
        const result = await courseModel.assignCourse(courseId, lecturerId);

        // If success, send email notification to lecturer
        const mailOptions = {
            from: process.env.AUTH_EMAIL,
            to: lecturerEmail,
            subject: "New Course Assigned: " + courseName,
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;">
                    <div style="text-align: center; margin-bottom: 20px;">
                        <img src="https://i.imgur.com/LndAkqq.png" alt="IntelliClass Logo" style="max-width: 150px; height: auto;">
                    </div>
                    <h2 style="color: #4CAF50; text-align: center;">New Course Assigned: ${courseName}</h2>
                    <p style="font-size: 16px; color: #333;">Hi there,</p>
                    <p style="font-size: 16px; color: #333;">
                        You have been assigned to the course ${courseName} for course code ${courseCode}. Please login to apps and check your dashboard for more details.
                    </p>
                    <p style="font-size: 14px; color: #555;">If you have any questions or need assistance, feel free to contact our support team.</p>
                    <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
                    <p style="font-size: 12px; color: #999; text-align: center;">&copy; ${new Date().getFullYear()} IntelliClass. All rights reserved.</p>
                </div>
            `
        };

        await transporter.sendMail(mailOptions);

        return result;
    } catch (error) {
        throw new Error(error.message);
    }
};

//Function to soft delete course
const softDeleteCourse = async (courseId) => {
    try {
        const result = await courseModel.softDeleteCourse(courseId);
        return result;
    } catch (error) {
        throw new Error(error.message);
    }
};

//Funciton to get deleted course
const getDeletedCourse = async () => {
    try {
        const result = await courseModel.getDeletedCourse();
        return result;
    } catch (error) {
        throw new Error(error.message);
    }
};

//Function to restore course
const restoreCourse = async (courseId) => {
    try {
        const result = await courseModel.restoreCourse(courseId);
        return result;
    } catch (error) {
        throw new Error(error.message);
    }
};

//Function to completely delete course
const deleteCourse = async (courseId) => {
    try {
        const result = await courseModel.deleteCourse(courseId);
        return result;
    } catch (error) {
        throw new Error(error.message);
    }
};

//Get user email for spesific courseId
const getUserEmail = async (courseId) => {
    try {
        const result = await courseModel.getUserEmail(courseId);
        return result;
    } catch (error) {
        throw new Error(error.message);
    }
};

//EXport module
module.exports = { viewCourse , addCourse, fetchImageFromGoogle, getCourseByLecturerId , editCourse, softDeleteCourse , getDeletedCourse , restoreCourse , deleteCourse, getUserEmail, getLecturers , assignCourse, getAssignedLecturers , studentViewCourses, lecturerViewCourses };
