const classModel = require("../models/classModel");
const attendanceService = require("../services/attendanceService");
const courseService = require("../services/courseService");

const nodemailer = require("nodemailer");

//nodemailer stuff
let transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
        user: process.env.AUTH_EMAIL,
        pass: process.env.AUTH_PASSWORD
    }
})

// Function to add a class
const addClass = async (classData) => {
    try {
        const { courseId, classLocation, timeStart, timeEnd, date, lecturerId } = classData;

        console.log("[DEBUG] Starting to add class...");

        const classId = await classModel.addClass(courseId, classLocation, timeStart, timeEnd, date, lecturerId);
        console.log("[DEBUG] Class added with ID:", classId);

        if (classId) {
            try {
                console.log("[DEBUG] Adding student attendance...");
                await attendanceService.addStudentAttendance(classId, courseId);
                console.log("[DEBUG] Student attendance added successfully.");

                const results = await courseService.getUserEmail(courseId);
                console.log("[DEBUG] Retrieved user emails:", results);

                if (!Array.isArray(results) || results.length === 0) {
                    console.warn("[WARN] No users found for the course. Skipping email.");
                    return { success: true, classId };
                }

                // Verify transporter is ready
                try {
                    await transporter.verify();
                    console.log("[DEBUG] Email transporter is ready.");
                } catch (verifyError) {
                    console.error("[ERROR] Transporter verification failed:", verifyError);
                    return { success: false, error: "Transporter error" };
                }

                // Extract emails
                const emails = results.map(r => r.userEmail).filter(Boolean);

                // Use the first record to get class info (assuming all students share the same courseName etc.)
                const { courseName, classroomName } = results[0];

                const mailOptions = {
                    from: process.env.AUTH_EMAIL,
                    bcc: emails,
                    subject: "Hi! You Got a New Class - IntelliClass",
                    html: `
                        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px; background-color: #ffffff;">
                            <div style="text-align: center; margin-bottom: 20px;">
                                <img src="https://i.imgur.com/LndAkqq.png" alt="IntelliClass Logo" style="max-width: 150px;">
                            </div>
                            <div style="text-align: center;">
                                <img src="https://cdn-icons-png.flaticon.com/512/3135/3135768.png" alt="Class Icon" width="60" height="60" style="margin-bottom: 10px;">
                                <h2 style="color: #4CAF50; font-size: 24px; margin: 0;">New Class Scheduled!</h2>
                            </div>
                            <p style="font-size: 16px; color: #333; margin-top: 20px;">
                                Hello, a new class has been added to your course in IntelliClass! Please check your schedule for the full details.
                            </p>
                            <div style="background-color: #f9f9f9; padding: 15px; border-radius: 8px; margin-top: 10px;">
                                <p style="font-size: 15px; color: #333;"><strong>📚 Course:</strong> ${courseName}</p>
                                <p style="font-size: 15px; color: #333;"><strong>📍 Location:</strong> ${classroomName}</p>
                                <p style="font-size: 15px; color: #333;"><strong>📅 Date:</strong> ${date}</p>
                                <p style="font-size: 15px; color: #333;"><strong>🕒 Time:</strong> ${timeStart} - ${timeEnd}</p>
                            </div>
                            <p style="font-size: 14px; color: #555; margin-top: 20px;">
                                If you have any questions or need assistance, feel free to contact our support team.
                            </p>
                            <p style="font-size: 14px; color: #555;">Thank you for using <strong>IntelliClass</strong>!</p>
                            <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
                            <p style="font-size: 12px; color: #999; text-align: center;">&copy; ${new Date().getFullYear()} IntelliClass. All rights reserved.</p>
                        </div>
                    `
                };

                try {
                    console.log(`[DEBUG] Sending email to: ${emails.length} students via BCC`);
                    const info = await transporter.sendMail(mailOptions);
                    console.log(`[SUCCESS] Bulk email sent. MessageId: ${info.messageId}`);

                    if (nodemailer.getTestMessageUrl(info)) {
                        console.log(`Preview URL: ${nodemailer.getTestMessageUrl(info)}`);
                    }

                } catch (emailError) {
                    console.error("[ERROR] Failed to send email to students:", emailError);
                }

            } catch (error) {
                console.error("[ERROR] Error in service while adding student attendance:", error);
            }
        }

        // IF classId is not null, it means the class was added successfully
        if (!classId) {
            return { success: false, error: "Failed to add class" };
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
