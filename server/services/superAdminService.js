const superAdminModel = require("../models/superAdminModel");

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

const getAllUsers = async () => {
    try {
        return await superAdminModel.getAllUsers();
    } catch (error) {
        throw new Error("Error in service while fetching all users: " + error.message);
    }
};

//Get all pending approvals
const getAllPendingApprovals = async () => {
    try {
        return await superAdminModel.getAllPendingApprovals();
    } catch (error) {
        throw new Error("Error in service while fetching all pending approvals: " + error.message);
    }
};

//Update approval status
const updateApprovalStatus = async (userId , status , email) => {
    try {
        //Update approval status
        const result = await superAdminModel.updateApprovalStatus(userId, status);

        //Send email to user
        if (result.affectedRows > 0) {
            let mailOptions = {};
            if (status === "Approved") {
                mailOptions = {
                    from: process.env.AUTH_EMAIL,
                    to: email,
                    subject: "Your account has been approved!",
                    html: `
                        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;">

                            <!-- Logo Section -->
                            <div style="text-align: center; margin-bottom: 20px;">
                                <img src="https://i.imgur.com/LndAkqq.png" alt="IntelliClass Logo" style="max-width: 150px; height: auto;">
                            </div>

                            <!-- Welcome Heading -->
                            <h2 style="color: #4CAF50; text-align: center;">Your Account Has Been Approved!</h2>

                            <!-- Body Content -->
                            <p style="font-size: 16px; color: #333;">Hi there,</p>
                            <p style="font-size: 16px; color: #333;">
                                Great news! Your account registration has been reviewed and approved by the IntelliClass team. You can now log in and start using the platform.
                            </p>

                            <!-- Additional Info -->
                            <p style="font-size: 14px; color: #555;">If you have any questions or need assistance, feel free to contact our support team.</p>
                            
                            <!-- Footer -->
                            <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
                            <p style="font-size: 12px; color: #999; text-align: center;">&copy; ${new Date().getFullYear()} IntelliClass. All rights reserved.</p>
                        </div>
                    `

                };
            } else if (status === "Rejected") {
                
                //Delete user
                await superAdminModel.deleteUser(userId);

                //Send Email
                mailOptions = {
                    from: process.env.AUTH_EMAIL,
                    to: email,
                    subject: "Your account has been rejected!",
                    html: `
                        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;">
                        <!-- Logo Section -->
                        <div style="text-align: center; margin-bottom: 20px;">
                            <img src="https://i.imgur.com/LndAkqq.png
                            " alt="IntelliClass Logo" style="max-width: 150px; height: auto;">
                        </div>

                        <!-- Welcome Heading -->
                        <h2 style="color: #4CAF50; text-align: center;">Your Account Has Been Rejected!</h2>

                        <!-- Body Content -->
                        <p style="font-size: 16px; color: #333;">Hi there,</p>
                        <p style="font-size: 16px; color: #333;">Sorry to inform you that your account has been rejected by admin. Please try again later.</p>
                        
                        <!-- Footer -->
                        <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
                        <p style="font-size: 12px; color: #999; text-align: center;">&copy; ${new Date().getFullYear()} IntelliClass. All rights reserved.</p>
                        </div>
                    `
                };
            }
            await transporter.sendMail(mailOptions);
        }

    } catch (error) {
        throw new Error("Error in service while updating approval status: " + error.message);
    }
};


//Function to disable user
const disableUser = async (userId , email) => {
    try {
        const result = await superAdminModel.disableUser(userId , email);

        //Send email to user
        if (result.affectedRows > 0) {
            let mailOptions = {};
            mailOptions = {
                from: process.env.AUTH_EMAIL,
                to: email,
                subject: "Your account has been disabled!",
                html: `
                    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;">

                        <!-- Logo Section -->
                        <div style="text-align: center; margin-bottom: 20px;">
                            <img src="https://i.imgur.com/LndAkqq.png
                            " alt="IntelliClass Logo" style="max-width: 150px; height: auto;">
                        </div>

                        <!-- Welcome Heading -->
                        <h2 style="color: #4CAF50; text-align: center;">Your Account Has Been Disabled!</h2>

                        <!-- Body Content -->
                        <p style="font-size: 16px; color: #333;">Hi there,</p>
                        <p style="font-size: 16px; color: #333;">Sorry to inform you that your account has been disabled by admin. Please try again later.</p>
                        
                        <!-- Footer -->
                        <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
                        <p style="font-size: 12px; color: #999; text-align: center;">&copy; ${new Date().getFullYear()} IntelliClass. All rights reserved.</p>
                    </div>
                `
            };
            await transporter.sendMail(mailOptions);
        }
        return result;
    } catch (error) {
        throw new Error("Error in service while disabling user: " + error.message);
    }
};

module.exports = {
    getAllUsers,
    getAllPendingApprovals,
    updateApprovalStatus,
    disableUser,
}; 