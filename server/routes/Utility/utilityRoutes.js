const express = require("express");
const utilityController = require("../../controllers/Utility/utilityController");

const router = express.Router();

router.post("/addUtility", utilityController.addUtility); //Add a Utility
// router.get("/getUtility", utilityController.getUtility); //Get all Utility

module.exports = router;