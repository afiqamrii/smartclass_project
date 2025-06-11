const superAdminService = require("../services/superAdminService");

const getAllUsers = async (req, res) => {
    //Debug
    console.log("Received get all users request");
    try {
        const users = await superAdminService.getAllUsers();
        res.status(200).json({
            message: "Users fetched successfully",
            Data : users ?? [],
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

//Get all users by id
const getUserById = async (req, res) => {
    //Debug
    console.log("Received get user by id request");
    try {
        const userId = req.params.userId;
        const user = await superAdminService.getUserById(userId);
        res.status(200).json({
            message: "User fetched successfully",
            Data : user ?? [],
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

//Get all not approved users
const getAllPendingApprovals = async (req, res) => {
    //Debug
    console.log("Received get all pending approvals request");
    try {
        const users = await superAdminService.getAllPendingApprovals();
        res.status(200).json({
            message: "Users fetched successfully",
            Data : users ?? [],
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

//Approve user
const updateApprovalStatus = async (req, res) => {
    //Debug
    console.log("Received update approval status request");
    try {
        //Get parameters from request
        const userId = req.params.userId;
        const status = req.body.is_approved;
        const email = req.body.user_email;

        //Debug
        console.log("Received data:", userId, status , email);

        //Validate input
        if (!userId || userId.trim() === "") {
            console.error("Error: User ID is required");
            return res.status(400).json({ error: "User ID is required" });
        }

        //Validate input
        if (!status || status.trim() === "") {
            console.error("Error: Approval status is required");
            return res.status(400).json({ error: "Approval status is required" });
        }

        //Validate input
        if (!email || email.trim() === "") {
            console.error("Error: User email is required");
            return res.status(400).json({ error: "User email is required" });
        }
        
        //Call service
        const result = await superAdminService.updateApprovalStatus(userId , status, email);
        res.status(200).json({ message: "User approval status updated successfully", result });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

//Disable user
const disableUser = async (req, res) => {
    //Debug
    console.log("Received disable user request");
    try {
        //Get parameters from request
        const userId = req.params.userId;
        const email = req.body.user_email;
        const status = req.body.status;

        //Debug
        console.log("Received data:", userId, email);

        //Validate input
        if (!userId || userId.trim() === "") {
            console.error("Error: User ID is required");
            return res.status(400).json({ error: "User ID is required" });
        }

        //Validate input
        if (!email || email.trim() === "") {
            console.error("Error: User email is required");
            return res.status(400).json({ error: "User email is required" });
        }
        
        //Call service
        const result = await superAdminService.disableUser(userId , email , status);
        res.status(200).json({ message: "User disabled successfully", result });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = { 
    getAllUsers,
    getAllPendingApprovals,
    updateApprovalStatus,
    disableUser,
    getUserById,
 };