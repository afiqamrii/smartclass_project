const express = require("express");
const classController = require("../controllers/classController");
// const summarizationController = require("../controllers/summarizationController");


const router = express.Router();

router.post("/addclass", classController.addClass); // Add a class
router.get("/viewclass", classController.viewClass); // View all classes
router.put("/updateclass/:id", classController.updateClass); // Update a class
router.delete("/deleteclass/:id", classController.deleteClass);

module.exports = router;
