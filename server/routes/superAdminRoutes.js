const express = require("express");
const superAdminController = require("../controllers/superAdminController");
const superAdminAuth = require("../middlewares/superAdminAuth");
const router = express.Router();

//Middleware to check if user is superadmin
router.use(superAdminAuth);

//Routes
//SuperAdmin Get all users
router.get("/getallusers", superAdminController.getAllUsers);

//Get all user by id
router.get("/getuserbyid/:userId", superAdminController.getUserById);

//Get all pending approvals
router.get("/getallpendingapprovals", superAdminController.getAllPendingApprovals);

//Update approval status
router.put("/updateapprovalstatus/:userId", superAdminController.updateApprovalStatus);

//Disable user
router.put("/disableuser/:userId", superAdminController.disableUser);

module.exports = router;