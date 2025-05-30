
const UtilityService = require('../../services/Utility/utilityService');
const { createDevice } = require("../../utils/favoriotAPI");
const classroomService = require("../../services/classroomService");

const addUtility = async (req, res) => {
    try {

        const { name, group_developer_id , classroomId , utilityType , esp32_id  } = req.body;

        //Debuig
        console.log("Request body:", req.body);

        console.log("Esp32 ID:", esp32_id);

        

        // Validate request body
        if ( !name || name.trim() === "" , !group_developer_id || group_developer_id.trim() === "" , !classroomId , !utilityType ) {
            return res.status(400).json({ error: 'Utility name , Utility Type , classroom ID and Group Developer ID are required' });
        }

        // Sanitize/Format the utility name for Favoriot's group_name
        const favoriotDeviceName = name.replace(/\s+/g, ""); 

        // Payload to add device in Favoriot
        const payload = {
            device_name: favoriotDeviceName,
            active: true,
            group_developer_id: group_developer_id,
            description: name,
            device_type: "ESP32",
            sensor_type: "others",
            timezone: "Asia/Kuala_Lumpur",
            latitue: 0,
            longitude: 0,
        };

        // Debug print to check the payload
        console.log("Payload to Favoriot:", payload);

        let response;
        try {
            response = await createDevice(payload);
            console.log("Response from Favoriot:", response);
        } catch (err) {
            // Handle Favoriot duplicate device error
            if (err.response && err.response.status === 409) {
                return res.status(409).json({ error: "Device name already exists. Please use a different name." });
            }
            console.error("Error from Favoriot API:", err);
            return res.status(500).json({ error: "Failed to create device in Favoriot" });
        }

        // // Debug print to check the response
        // console.log("Response from Favoriot:", response);

        //Topic to add in the database
        const topic = `v2/streams/${favoriotDeviceName}`;

        //Add the topic and device_id to the request body
        req.body.topic = topic;
        req.body.device_id = favoriotDeviceName; 

        // Debug print to check the request body
        console.log("Request body:", req.body);

        // If successful, proceed to add the utility in the database
        // Call service to add utility
        const utility = await UtilityService.addUtility(req.body);

        //If success add esp32_id to the Classroom table
        if (esp32_id) {
            const updatedClassroom = await classroomService.updateEsp32Id(classroomId, esp32_id);
            if (!updatedClassroom) {
                return res.status(500).json({ error: "Failed to update esp32_id in Classroom" });
            }
        }

        //Emit to WebSocket when utility status is updated
        if (global._io) {
            global._io.emit('utility_status_update', { classroomId  });
            console.log('📡 Successfully emitted utility update event to WebSocket');
        }

        res.status(200).json({ message: 'Utility added successfully', utility });
    } catch (error) {
            if (error.message === "DUPLICATE_UTILITY_NAME") {
                return res.status(409).json({ error: "Utility name already exists. Please choose a different name." });
            }
            res.status(500).json({ error: error.message });
    }
};

//Get all utilities
const getAllUtilities = async (req, res) => {
    try {
        //Get parameters from request
        const classroomId = req.params.classroomId;

        // Call service to retrieve all utilities
        const utilities = await UtilityService.getAllUtilities(classroomId);

        if (utilities.length === 0) {
            return res.status(404).json({ message: "No utilities found for this classroom" });
        }

        res.status(200).json({ 
            message: "Utilities retrieved successfully",
            Data: utilities,
        });
    } catch (error) {
        console.error("Error retrieving utilities:", error);
        res.status(500).json({ error: 'Failed to retrieve utilities' });
    }
};

//Function to update utility status by ID
const updateUtilityStatus = async (req, res) => {
    const { utilityStatus , classroomId } = req.body;
    const utilityId = req.params.utilityId;

    // Validate input
    if (utilityStatus == "" || utilityId == "") {
        return res.status(400).json({ error: 'Status and Utility ID are required' });
    }

    try {
        // Call service to update utility status
        const updatedUtility = await UtilityService.updateUtilityStatus(utilityId, utilityStatus);

        //Emit to WebSocket when utility status is updated
        if (global._io) {
            global._io.emit('utility_status_update', { classroomId ,utilityStatus , utilityId });
            console.log('📡 Successfully emitted utility update event to WebSocket');
        }


        res.status(200).json({ message: 'Utility status updated successfully', updatedUtility });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = {
    addUtility,
    getAllUtilities,
    updateUtilityStatus,
};