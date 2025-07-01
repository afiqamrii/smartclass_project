const enrollmentModel = require("../models/enrollmentModel");

const nodemailer = require("nodemailer");

//nodemailer stuff
let transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
        user: process.env.AUTH_EMAIL,
        pass: process.env.AUTH_PASSWORD
    }
})

//Testing success
transporter.verify(function(error, success) {
    if (error) {
        console.log(error);
    } else {
        console.log("Server is ready to take our messages");
        console.log(success);
    }
})

// Function to enroll a student in a course
exports.enrollStudent = async (studentId, courseId, studentEmail, lecturerEmail, courseName , lecturerId) => {
    try {
        const result = await enrollmentModel.enrollStudent(studentId, courseId, lecturerId);

        //Debugging purpose
        // console.log("Enrollment result:", result);
        // console.log("Student ID:", studentId);
        // console.log("Course ID:", courseId);
        // console.log("Student Email:", studentEmail);
        // console.log("Lecturer Email:", lecturerEmail);
        // console.log("Course Name:", courseName);

        //If success, send email notification to student and also lecturer
        if (result) {
            // Prepare email options for student
            const studentMailOptions = {
                from: process.env.AUTH_EMAIL,
                to: studentEmail,
                subject: "Enrollment Successful for " + courseName,
                html: `
                    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;">

                            <!-- Logo Section -->
                            <div style="text-align: center; margin-bottom: 20px;">
                                <img src="https://i.imgur.com/LndAkqq.png" alt="IntelliClass Logo" style="max-width: 150px; height: auto;">
                            </div>

                            <!-- Welcome Heading -->
                            <h2 style="color: #4CAF50; text-align: center;">Your Enrollment for ${courseName} Has Been Sent to the Lecturer!</h2>

                            <!-- Body Content -->
                            <p style="font-size: 16px; color: #333;">Hi there,</p>
                            <p style="font-size: 16px; color: #333;">
                                Great news! Your enrollment has been sent to the lecturer. You'll be notified once the enrollment is being accepted.
                            </p>

                            <!-- Additional Info -->
                            <p style="font-size: 14px; color: #555;">If you have any questions or need assistance, feel free to contact our support team.</p>
                            
                            <!-- Footer -->
                            <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
                            <p style="font-size: 12px; color: #999; text-align: center;">&copy; ${new Date().getFullYear()} IntelliClass. All rights reserved.</p>
                        </div>
                `
            };

            // Send email to student
            await transporter.sendMail(studentMailOptions);

            // Prepare email options for lecturer
            const lecturerMailOptions = {
                from: process.env.AUTH_EMAIL,
                to: lecturerEmail,
                subject: "New Student Enrollment for " + courseName,
                html: `
                    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;">

                            <!-- Logo Section -->
                            <div style="text-align: center; margin-bottom: 20px;">
                                <img src="https://i.imgur.com/LndAkqq.png" alt="IntelliClass Logo" style="max-width: 150px; height: auto;">
                            </div>

                            <!-- Welcome Heading -->
                            <h2 style="color: #4CAF50; text-align: center;">New Student Enrollment for ${courseName}!</h2>

                            <!-- Body Content -->
                            <p style="font-size: 16px; color: #333;">Hi there,</p>
                            <p style="font-size: 16px; color: #333;">
                                A new student has enrolled in your course ${courseName}. Please review the enrollment details and accept or reject the enrollment.
                            </p>

                            <!-- Additional Info -->
                            <p style="font-size: 14px; color: #555;">If you have any questions or need assistance, feel free to contact our support team.</p>
                            
                            <!-- Footer -->
                            <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
                            <p style="font-size: 12px; color: #999; text-align: center;">&copy; ${new Date().getFullYear()} IntelliClass. All rights reserved.</p>
                    </div>
                `
            };

            // Send email to lecturer
            await transporter.sendMail(lecturerMailOptions);
        }

    } catch (error) {
        // If the error is due to a duplicate entry, throw a specific error
        if (error.status === 409) {
            throw new Error("You have already enrolled in this course. Only one enrollment per course is allowed!");
        }
        throw new Error("Error in service while enrolling student: " + error.message);
    }
};

//+// Function to get all enrollments for a student
exports.getStudentEnrollment = async (studentId) => {
    try {
        return await enrollmentModel.getStudentEnrollment(studentId);
    } catch (error) {
        throw new Error("Error in service while fetching student enrollments: " + error.message);
    }
};

// Function to get enrollments for a course for a lecturer to verify
exports.lecturerGetEnrollment = async (lecturerId, courseId) => {
    try {
        return await enrollmentModel.lecturerGetEnrollment(lecturerId, courseId);
    } catch (error) {
        console.error("Service Error:", error);
        throw new Error("Failed to retrieve enrollment data.");
    }
};


// Function to get all enrollments for a student
exports.getAllEnrollments = async (studentId) => {
    try {
        return await enrollmentModel.getAllEnrollments(studentId);
    } catch (error) {
        throw new Error("Error in service while fetching all enrollments: " + error.message);
    }
};

// Function to update enrollment status
exports.updateEnrollmentStatus = async (enrollmentId, status, email, courseName, courseCode) => {
    try {
        // Validate input
        if (!enrollmentId || !status) {
            throw new Error("Enrollment ID and status are required");
        }

        // Call the model function to update enrollment status
        const result = await enrollmentModel.updateEnrollmentStatus(enrollmentId, status);

        if (!result || result.affectedRows === 0) {
            throw new Error("No enrollment found with the provided ID");
        }

        // Debugging purpose
        console.log("Enrollment status updated successfully:", result);

        // Prepare email options based on status
        let subject, message;
        if (status === "Approved") {
            subject = "Enrollment Approved for " + courseName;
            message = `
                <p style="font-size: 16px; color: #333;">
                    Congratulations! Your enrollment for the course ${courseName} for course code ${courseCode} has been approved. You can now access the course materials.
                </p>
            `;
        } else if (status === "Rejected") {
            subject = "Enrollment Rejected for " + courseName;
            message = `
                <p style="font-size: 16px; color: #333;">
                    We regret to inform you that your enrollment for the course ${courseName} for course code ${courseCode} has been rejected. Please contact support for further assistance.
                </p>
            `;
        }

        if (subject && message) {
            const mailOptions = {
                from: process.env.AUTH_EMAIL,
                to: email,
                subject: subject,
                html: `
                    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;">
                        <div style="text-align: center; margin-bottom: 20px;">
                            <img src="https://i.imgur.com/LndAkqq.png" alt="IntelliClass Logo" style="max-width: 150px; height: auto;">
                        </div>
                        <h2 style="color: #4CAF50; text-align: center;">${subject}</h2>
                        <p style="font-size: 16px; color: #333;">Hi there,</p>
                        ${message}
                        <p style="font-size: 14px; color: #555;">If you have any questions or need assistance, feel free to contact our support team.</p>
                        <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
                        <p style="font-size: 12px; color: #999; text-align: center;">&copy; ${new Date().getFullYear()} IntelliClass. All rights reserved.</p>
                    </div>
                `
            };

            await transporter.sendMail(mailOptions);
        }

    } catch (error) {
        console.error("Service Error:", error);
        throw new Error("Failed to update enrollment status.");
    }
};

//Get all student Id that enroll for spesific course
exports.getAllEnrollment = async (courseId) => {
    try {
        return await enrollmentModel.getAllEnrollment(courseId);
    } catch (error) {
        throw new Error("Error in service while fetching all enrollments: " + error.message);
    }
};

// Function to withdraw enrollment
exports.withdrawEnrollment = async (enrollmentId, studentId) => {
    try {
        // Validate input
        if (!enrollmentId || !studentId) {
            throw new Error("Enrollment ID and Student ID are required");
        }
        // Call the model function to withdraw enrollment
        return await enrollmentModel.withdrawEnrollment(enrollmentId, studentId);
    } catch (error) {
        console.error("Service Error:", error);
        throw new Error("Failed to withdraw enrollment.");
    }
};