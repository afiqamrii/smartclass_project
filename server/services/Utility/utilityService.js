const UtilityModel = require('../../models/Utility/utilityModel');

// Function to add a new utility
const addUtility = async (utility) => {
    try {
        console.log("Adding utility:", utility);
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

//Function to delete utility by ID
const deleteUtility = async (utilityId) => {
    try {
        const deletedUtility = await UtilityModel.deleteUtility(utilityId);
        return deletedUtility;
    } catch (error) {
        throw new Error("Error in service while deleting utility: " + error.message);
    }
};

module.exports = {
    addUtility,
    getAllUtilities,
    updateUtilityStatus,
    deleteUtility
};
