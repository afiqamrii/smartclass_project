const classroomModel = require("../models/classroomModel");

//Function to add a new classroom
const addClassroom = async (classroom) => {
    try {
        const newClassroom = await classroomModel.addClassroom(classroom);
        return newClassroom;
    } catch (error) {
        throw new Error(error.message);
    }
};

//Function to update esp32_id in the Classroom table
const updateEsp32Id = async (classroomId, esp32_id) => {
    try {
        const updated = await classroomModel.updateEsp32Id(classroomId, esp32_id);
        return updated;
    } catch (error) {
        throw new Error("Error in service while updating esp32_id: " + error.message);
    }
};

// Function to view course
const getClassroom = async () => {
    try {
        const classroom = await classroomModel.getAllClassroom();
        return classroom || [];
    } catch (error) {
        throw new Error("Error in service while fetching classroom data: " + error.message);
    }
};

// Function to get classroom by esp32 ID
const getClassroomByEsp32Id = async (esp32Id) => {
    try {
        if (!esp32Id || esp32Id.trim() === "") {
            throw new Error("ESP32 ID is required");
        }
        const classroom = await classroomModel.getClassroomByEsp32Id(esp32Id);
        return classroom;
    } catch (error) {
        throw new Error("Error in service while fetching classroom by esp32 ID: " + error.message);
    }
};

//Function to delete classroom
const softDeleteClassroom = async (classroomId) => {
    try {

        //soft delete it
        const result = await classroomModel.softDeleteClassroom(classroomId);

        return result;
    } catch (error) {
        throw new Error("Error in service while deleting classroom data: " + error.message);
    }
};

//Function to get deleted classroom
const getDeletedClassroom = async () => {
    try {
        const classroom = await classroomModel.getDeletedClassroom();
        return classroom || [];
    } catch (error) {
        throw new Error("Error in service while fetching classroom data: " + error.message);
    }
};

//Function to restore deleted classroom
const restoreClassroom = async (classroomId) => {
    try {
        const result = await classroomModel.restoreClassroom(classroomId);
        return result;
    } catch (error) {
        throw new Error("Error in service while restoring classroom data: " + error.message);
    }
};

//Function to completely delete classroom
const deleteClassroom = async (classroomId) => {
    try {
        const result = await classroomModel.deleteClassroom(classroomId);
        return result;
    } catch (error) {
        throw new Error("Error in service while deleting classroom data: " + error.message);
    }
};

//Function to edit classroom
const editClassroom = async (classroomId, updatedClassroom) => {
    try {
        const result = await classroomModel.editClassroom(classroomId, updatedClassroom);
        return result;
    } catch (error) {
        throw new Error("Error in service while updating classroom data: " + error.message);
    }
};

//EXport module
module.exports = { getClassroom , addClassroom , updateEsp32Id , getClassroomByEsp32Id , softDeleteClassroom , getDeletedClassroom, restoreClassroom , deleteClassroom, editClassroom };
