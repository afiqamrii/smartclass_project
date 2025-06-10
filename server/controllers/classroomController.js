const e = require("express");
const classroomService = require("../services/classroomService");
const { createGroup } = require("../utils/favoriotAPI");

// Function to add a new classroom
exports.addClassroom = async (req, res) => {
    try {
        const { classroomName } = req.body;

        // Validate input
        if (!classroomName || classroomName.trim() === "") {
            return res.status(400).json({ message: "Classroom name is required" });
        }

        // Sanitize/Format the classroomName for Favoriot's group_name
        const favoriotGroupName = classroomName.replace(/\s+/g, ""); // "DewanShahrukhKhan"

        //Group ID
        //Create groupDevID
        const groupDevId = `${classroomName.replace(/\s+/g, "")}@${process.env.FAVORIOT_USERNAME}`;

        // Call service to add classroom
        const newClassroom = await classroomService.addClassroom({ classroomName , groupDevId });

        // Check if the error is duplicate entry
        if (newClassroom instanceof Error && newClassroom.message.includes("Duplicate entry")) {
            return res.status(409).json({ message: "Classroom name already exists" });
        }

        // //If successfully added 
        // //Create group in Favoriot
        // if (newClassroom) {
        //     const groupPayload = {
        //         group_name: favoriotGroupName,
        //         group_developer_id: groupDevId,
        //         active: true,
        //         application_developer_id: process.env.FAVORIOT_APP_ID,
        //         description: `Group for ${classroomName}`,
        //         user_id: process.env.FAVORIOT_USERNAME,
        //     };

        //     //Print
        //     console.log("Creating group with payload:", groupPayload);

        //     // Create group in Favoriot
        //     await createGroup(groupPayload);
        // }


        res.status(200).json({
            message: "Classroom added successfully",
            Data: newClassroom,
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: error.message });
    }
};

// Function to view all courses
exports.getClassroom = async (req, res) => {
    try {
        const classroom = await classroomService.getClassroom();
        res.status(200).json({
            message: "Classroom data fetched successfully",
            Data: classroom ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch classroom data" });
    }
};

// Function to get classroom by esp32 ID
exports.getClassroomByEsp32Id = async (req, res) => {
    try {
        const esp32Id = req.params.esp32Id;

        //Debugging log
        console.log("Received request to get classroom by esp32 ID:", { esp32Id });

        // Validate input
        if (!esp32Id || esp32Id.trim() === "") {
            return res.status(400).json({ message: "ESP32 ID is required" });
        }

        // Call service to get classroom by esp32 ID
        const classroom = await classroomService.getClassroomByEsp32Id(esp32Id);

        if (!classroom) {
            return res.status(404).json({ message: "Classroom not found for the given ESP32 ID" });
        }

        // Format the response
        const groupId = classroom[0].group_developer_id;
        const devices = classroom.map(row => ({ name: row.device_id }));

        //Respond with the classroom data
        res.status(200).json({
            groupId,
            devices
        });

    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch classroom data" });
    }
};

//Function to delete classroom
exports.softDeleteClassroom = async (req, res) => {
    try {
        const classroomId = req.params.classroomId;
        const result = await classroomService.softDeleteClassroom(classroomId);
        res.status(200).json({ message: "Classroom data deleted successfully", Deleted_Id: result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(400).json({ message: err.message });
    }
};

//Function to get deleted classroom
exports.getDeletedClassroom = async (req, res) => {
    try {
        const classroom = await classroomService.getDeletedClassroom();
        res.status(200).json({
            message: "Classroom data fetched successfully",
            Data: classroom ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch classroom data" });
    }
};

//Fcuntion to restore classroom
exports.restoreClassroom = async (req, res) => {
    try {
        const classroomId = req.params.classroomId;
        const result = await classroomService.restoreClassroom(classroomId);
        res.status(200).json({ message: "Classroom data restored successfully", Restored_Id: result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(400).json({ message: err.message });
    }
};

//Function to completely delete classroom
exports.deleteClassroom = async (req, res) => {
    try {
        const classroomId = req.params.classroomId;
        const result = await classroomService.deleteClassroom(classroomId);
        res.status(200).json({ message: "Classroom data deleted successfully", Deleted_Id: result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(400).json({ message: err.message });
    }
};

//Edit classroom
exports.editClassroom = async (req, res) => {
    try {
        const classroomId = req.params.classroomId;
        const updatedClassroom = req.body;
        const result = await classroomService.editClassroom(classroomId, updatedClassroom);
        res.status(200).json({ message: "Classroom data updated successfully", Updated_Id: result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(400).json({ message: err.message });
    }
}