
const UtilityService = require('../../services/Utility/utilityService');
const { createDevice } = require("../../utils/favoriotAPI");

const addUtility = async (req, res) => {
    try {

        const { name, group_developer_id , classroomId  } = req.body;

        //Debuig
        console.log("Request body:", req.body);

        // Validate request body
        if ( !name || name.trim() === "" , !group_developer_id || group_developer_id.trim() === "" , !classroomId  ) {
            return res.status(400).json({ error: 'Utility name , classroom ID and Group Developer ID are required' });
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

        // // Debug print to check the payload
        // console.log("Payload to Favoriot:", payload);

        // Send the payload to Favoriot to create the device
        await createDevice(payload);

        //Topic to add in the database
        const topic = `v2/streams/${favoriotDeviceName}`;

        //Add the topic and device_id to the request body
        req.body.topic = topic;
        req.body.device_id = favoriotDeviceName; 

        // If successful, proceed to add the utility in the database
        // Call service to add utility
        const utility = await UtilityService.addUtility(req.body);
        res.status(201).json({ message: 'Utility added successfully', utility });
    } catch (error) {
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