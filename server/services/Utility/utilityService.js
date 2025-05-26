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

module.exports = {
    addUtility
};
