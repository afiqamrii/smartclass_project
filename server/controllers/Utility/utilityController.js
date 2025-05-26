
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

module.exports = {
    addUtility
};