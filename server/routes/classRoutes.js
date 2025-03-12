const express = require("express");
const classController = require("../controllers/classController");

const router = express.Router();

router.post("/addclass", classController.addClass);
router.get("/viewclass", classController.viewClass);
// router.get("/viewSummarizationStatus", classController.viewSummarizationStatus);
// router.put("/updateclass/:id", classController.updateClass);
// router.delete("/deleteclass/:id", classController.deleteClass);

module.exports = router;
