const express = require("express");
const utilityController = require("../../controllers/Utility/utilityController");

const router = express.Router();

router.post("/addUtility", utilityController.addUtility); //Add a Utility
router.get("/getUtility/:classroomId", utilityController.getAllUtilities); //Get all Utility

//Route to update utility status
router.put("/updateUtilityStatus/:utilityId", utilityController.updateUtilityStatus); //Update utility status

module.exports = router;