const UtilityModel = require('../../models/Utility/utilityModel');

// Function to add a new utility
const addUtility = async (utility) => {
    try {
        const newUtility = await UtilityModel.addUtility(utility);
        return newUtility;
    } catch (error) {
        throw new Error("Error in service while adding utility: " + error.message);
    }
};

//Get all utilities
const getAllUtilities = async (classroomId) => {
    try {
        const utilities = await UtilityModel.getAllUtilities(classroomId);
        return utilities;
    } catch (error) {
        throw new Error("Error in service while retrieving utilities: " + error.message);
    }
};

// Function to update utility status by ID
const updateUtilityStatus = async (utilityId, utilityStatus) => {
    try {
        const updatedUtility = await UtilityModel.updateUtilityStatus(utilityId, utilityStatus);
        return updatedUtility;
    } catch (error) {
        throw new Error("Error in service while updating utility status: " + error.message);
    }
};

module.exports = {
    addUtility,
    getAllUtilities,
    updateUtilityStatus,
};
