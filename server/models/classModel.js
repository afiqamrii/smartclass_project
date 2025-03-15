const pool = require("../config/database").pool;
const moment = require("moment");

const ClassModel = {
    // Add a class to the database
    async addClass(courseCode, className, date, timeStart, timeEnd, classLocation){
        try {
            const query = `
            INSERT INTO class (courseCode, className, date, timeStart, timeEnd, classLocation)
            VALUES (?, ?, ?, ?, ?, ?)
            `;
            const values = [courseCode, className, date, timeStart, timeEnd, classLocation];
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
    async getAllClasses(){
        try{
            const query = `
            SELECT * FROM class ORDER BY date DESC, timeStart DESC;
            `;
            const [rows] = await pool.query(query);
            return rows;
        }
        catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    //Update Class
    async updateClass(id, courseCode, className, date, timeStart, timeEnd, classLocation) {
        const query = `
            UPDATE class
            SET courseCode = ?, className = ?, date = ?, timeStart = ?, timeEnd = ?, classLocation = ?
            WHERE classId = ?
        `;
        const values = [courseCode, className, date, timeStart, timeEnd, classLocation, id];
    
        console.log("Executing SQL:", query);
        console.log("With values:", values);
    
        await pool.query(query, values);
        return id;
    },
    

    //Delete Class
    async deleteClass(id) {
        const query = `DELETE FROM class WHERE classId = ?`;
        await pool.query(query, [id]);
        return id;
    }
};

module.exports = ClassModel;