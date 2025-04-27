const pool = require("../config/database").pool;
const moment = require("moment");

const ClassModel = {
    // Add a class to the database
    async addClass(courseCode, className, date, timeStart, timeEnd, classLocation , lecturerId , imageUrl) {
        try {
            const query = `
            INSERT INTO ClassSession (courseCode, className, date, timeStart, timeEnd, classLocation ,lecturerId , imageUrl)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            `;
            const values = [courseCode, className, date, timeStart, timeEnd, classLocation , lecturerId , imageUrl];
            const [result] = await pool.query(query, values);
            console.log("Class added successfully:", result);
            return result.insertId;
        }
        catch (err) {
            console.error("Error inserting data:", err.message);
            return null;
        }
    },

    // Retrieve all classes from the database
    async getAllClasses(lecturerId){
        try{
            const query = `
            SELECT * FROM ClassSession
            WHERE lecturerId = ?
            ORDER BY date DESC, timeStart DESC;
            `;
            const [rows] = await pool.query(query,[lecturerId]);
            return rows;
        }
        catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    // Retrieve a class by its ID
    async getClassById(id) {    
        try {
            const query = `SELECT * FROM ClassSession WHERE classId = ?`;
            const [rows] = await pool.query(query, [id]);
            return rows[0] || null;
        }
        catch (err) {
            console.error("Error retrieving data:", err.message);
            return null;
        }
    },

    // Retrieve today's classes for students
    async studentViewTodayClass() {
        try {
            const today = moment().format("YYYY-MM-DD");
            const query = `
            SELECT 
                cs.classId,
                cs.courseCode,
                cs.className,
                cs.date,
                cs.timeStart,
                cs.timeEnd,
                cs.classLocation,
                cs.imageUrl,
                cr.publishStatus,
                u.name
            FROM 
                ClassSession cs
            JOIN 
                User u ON cs.lecturerId = u.externalId
            LEFT JOIN 
                ClassRecording cr ON cs.classId = cr.classId

            WHERE 
                cs.date = ?
            `;
            const [rows] = await pool.query(query, [today]);
            console.log("Today's classes:", today);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    // Student view upcoming class
    async viewUpcomingClass() {
        try {
            const today = moment().format("YYYY-MM-DD");
            const query = `
            SELECT 
                cs.classId,
                cs.courseCode,
                cs.className,
                cs.date,
                cs.timeStart,
                cs.timeEnd,
                cs.classLocation,
                cs.imageUrl,
                cr.publishStatus,
                u.name
            FROM 
                ClassSession cs
            JOIN 
                User u ON cs.lecturerId = u.externalId
            LEFT JOIN 
                ClassRecording cr ON cs.classId = cr.classId

            WHERE 
                cs.date > ?
            `;
            const [rows] = await pool.query(query, [today]);
            console.log("Upcoming classes:", today);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    //View passt class
    async viewPastClass(){
        try {
            const today = moment().format("YYYY-MM-DD");
            const query = `
            SELECT 
                cs.classId,
                cs.courseCode,
                cs.className,
                cs.date,
                cs.timeStart,
                cs.timeEnd,
                cs.classLocation,
                cs.imageUrl,
                cr.publishStatus,
                u.name
            FROM 
                ClassSession cs
            JOIN 
                User u ON cs.lecturerId = u.externalId
            LEFT JOIN 
                ClassRecording cr ON cs.classId = cr.classId

            WHERE 
                cs.date < ?
            `;
            const [rows] = await pool.query(query, [today]);
            console.log("Pass classes:", today);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    //View current class
    async viewCurrentClass(){
        try {
            const today = moment().format("YYYY-MM-DD");
            const currentTime = moment().format("HH:mm:ss");
            const query = `
            SELECT 
                cs.classId,
                cs.courseCode,
                cs.className,
                cs.date,
                cs.timeStart,
                cs.timeEnd,
                cs.classLocation,
                cs.imageUrl,
                cr.publishStatus,
                u.name
            FROM 
                ClassSession cs
            JOIN 
                User u ON cs.lecturerId = u.externalId
            LEFT JOIN 
                ClassRecording cr ON cs.classId = cr.classId

            WHERE 
                cs.date = ?
                AND cs.timeStart <= ?
                AND cs.timeEnd >= ?
            `;
            const [rows] = await pool.query(query, [today ,currentTime, currentTime]);
            // console.log("Current time:", currentTime);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    //Update Class
    async updateClass(id, courseCode, className, date, timeStart, timeEnd, classLocation , imageUrl) {

        //Debugging
        console.log("Update Class ID:", id);
        console.log("Update Class Data:", { courseCode, className, date, timeStart, timeEnd, classLocation , imageUrl });
        
        const query = `
            UPDATE ClassSession
            SET courseCode = ?, className = ?, date = ?, timeStart = ?, timeEnd = ?, classLocation = ? , imageUrl = ?
            WHERE classId = ?
        `;
        const values = [courseCode, className, date, timeStart, timeEnd, classLocation , imageUrl , id];
    
        console.log("Executing SQL:", query);
        console.log("With values:", values);
    
        await pool.query(query, values);
        return id;
    },
    

    //Delete Class
    async deleteClass(id) {
        const query = `DELETE FROM ClassSession WHERE classId = ?`;
        await pool.query(query, [id]);
        return id;
    }
};

module.exports = ClassModel;