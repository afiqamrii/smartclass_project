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


        res.status(201).json({
            message: "Classroom added successfully",
            Data: newClassroom,
        });
    } catch (error) {
        console.error("Controller Error:", error);
        if (error.isAxiosError && error.response) {
            console.error("Axios error response status:", error.response.status);
            console.error("Axios error response data:", error.response.data); // Log this!
        }
        res.status(500).json({ message: "Failed to add classroom" });
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