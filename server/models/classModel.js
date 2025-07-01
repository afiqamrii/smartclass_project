const pool = require("../config/database").pool;
const moment = require("moment");

const ClassModel = {
        // Add a class to the database
        async addClass(courseId, classLocation, timeStart, timeEnd, date, lecturerId) {
        try {
            const query = `
            INSERT INTO ClassSession (date, timeStart, timeEnd, classroomId, lecturerId, courseId)
            SELECT * FROM (
            SELECT ?, ?, ?, ?, ?, ?
            ) AS tmp
            WHERE NOT EXISTS (
            SELECT 1
            FROM ClassSession
            WHERE lecturerId = ?
                AND date = ?
                AND (
                (? BETWEEN timeStart AND timeEnd)
                OR (? BETWEEN timeStart AND timeEnd)
                OR (timeStart BETWEEN ? AND ?)
                OR (timeEnd BETWEEN ? AND ?)
                )
            );
            `;

            const values = [
            date, timeStart, timeEnd, classLocation, lecturerId, courseId,
            lecturerId, date,
            timeStart, timeEnd,
            timeStart, timeEnd,
            timeStart, timeEnd
            ];

            

            const [result] = await pool.query(query, values);

            //If no rows affected, it means the class already exists and return error to user
            if (result.affectedRows === 0) {
                // Debugging: Log the error message
                console.error("Class already exists for this day at the specified time.");
                return 0; 
            }

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
            // Debugging: Log the lecturerId being used
            console.log("Retrieving classes for lecturerId:", lecturerId);
            const query = `
            SELECT 
                cs.classId,
                c.courseCode,
                c.courseName AS className,
                cs.date,
                cs.timeStart,
                cs.timeEnd,
                cl.classroomName AS classLocation,
                c.imageUrl,
                cs.courseId

            FROM ClassSession cs
            JOIN Course c ON cs.courseId = c.courseId
            JOIN Classroom cl ON cs.classroomId = cl.classroomId
            WHERE cs.lecturerId = ?
            `;
            const [rows] = await pool.query(query,[lecturerId]);

            // Debugging: Log the retrieved classes
            console.log("Retrieved classes:", rows);
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
            const query = ` 
            SELECT 
                cs.classId,
                c.courseCode,
                c.courseName AS className,
                cs.date,
                cs.timeStart,
                cs.timeEnd,
                cl.classroomName AS classLocation,
                c.imageUrl,
                cs.courseId

            FROM ClassSession cs
            JOIN Course c ON cs.courseId = c.courseId
            JOIN Classroom cl ON cs.classroomId = cl.classroomId
            WHERE cs.classId = ?
        `;
            const [rows] = await pool.query(query, [id]);
            return rows[0] || null;
        }
        catch (err) {
            console.error("Error retrieving data:", err.message);
            return null;
        }
    },

    // Retrieve today's classes for students
    async studentViewTodayClass(studentId) {
        try {
            const today = moment().format("YYYY-MM-DD");
            const query = `
            SELECT 
                cs.classId,
                c.courseCode,
                c.courseName AS className,
                cs.date,
                cs.timeStart,
                cs.timeEnd,
                cl.classroomName AS classLocation,
                c.imageUrl,
                cr.publishStatus,
                u.name
            FROM 
                ClassSession cs
            JOIN 
                User u ON cs.lecturerId = u.externalId
            
            JOIN 
                Course c ON cs.courseId = c.courseId
            
            JOIN 
                Classroom cl ON cs.classroomId = cl.classroomId

            LEFT JOIN 
                ClassRecording cr ON cs.classId = cr.classId

            JOIN 
                CourseEnrollment ce ON cs.courseId = ce.courseId

            WHERE 
                cs.date = ? AND ce.student_id = ? AND ce.status = 'Approved'
            
            ORDER BY cs.timeStart ASC
            `;
            const [rows] = await pool.query(query, [today , studentId]);
            console.log("Today's classes:", today);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    // Student view upcoming class
    async viewUpcomingClass(studentId) {
        try {
            const today = moment().format("YYYY-MM-DD");
            const query = `
            SELECT 
                cs.classId,
                c.courseCode,
                c.courseName AS className,
                cs.date,
                cs.timeStart,
                cs.timeEnd,
                cl.classroomName AS classLocation,
                c.imageUrl,
                cr.publishStatus,
                u.name
            FROM 
                ClassSession cs
            JOIN 
                User u ON cs.lecturerId = u.externalId
            
            JOIN
                Course c ON cs.courseId = c.courseId
            
            JOIN 
                Classroom cl ON cs.classroomId = cl.classroomId
            
            JOIN 
                CourseEnrollment ce ON cs.courseId = ce.courseId

            LEFT JOIN 
                ClassRecording cr ON cs.classId = cr.classId

            WHERE 
                cs.date > ? AND ce.student_id = ? AND ce.status = 'Approved'
            
            ORDER BY cs.date ASC
            `;
            const [rows] = await pool.query(query, [today , studentId]);
            // console.log("Upcoming classes:", today);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    //View passt class
    async viewPastClass(studentId){
        try {
            const today = moment().format("YYYY-MM-DD");
            const query = `
            SELECT 
                cs.classId,
                c.courseCode,
                c.courseName AS className,
                cs.date,
                cs.timeStart,
                cs.timeEnd,
                cl.classroomName AS classLocation,
                c.imageUrl,
                cr.publishStatus,
                u.name
            FROM 
                ClassSession cs
            JOIN 
                User u ON cs.lecturerId = u.externalId
            
            JOIN
                Course c ON cs.courseId = c.courseId
            
            JOIN 
                Classroom cl ON cs.classroomId = cl.classroomId

            JOIN 
                CourseEnrollment ce ON cs.courseId = ce.courseId

            LEFT JOIN 
                ClassRecording cr ON cs.classId = cr.classId

            WHERE 
                cs.date < ? AND ce.student_id = ? AND ce.status = 'Approved'
            
            ORDER BY cs.date DESC

            `;
            const [rows] = await pool.query(query, [today , studentId]);
            
            //Debug
            // console.log ("Data retrieved:", rows);
            // console.log("Pass classes:", today);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    //View current class
    async viewCurrentClass(studentId){
        try {
            const today = moment().format("YYYY-MM-DD");
            const currentTime = moment().format("HH:mm:ss");
            const query = `
            SELECT 
                cs.classId,
                c.courseCode,
                c.courseName AS className,
                cs.date,
                cs.timeStart,
                cs.timeEnd,
                cl.classroomName AS classLocation,
                c.imageUrl,
                cr.publishStatus,
                u.name
            FROM 
                ClassSession cs
            JOIN 
                User u ON cs.lecturerId = u.externalId
            
            JOIN
                Course c ON cs.courseId = c.courseId
            
            JOIN 
                Classroom cl ON cs.classroomId = cl.classroomId
            
            JOIN 
                CourseEnrollment ce ON cs.courseId = ce.courseId

            LEFT JOIN 
                ClassRecording cr ON cs.classId = cr.classId

            WHERE 
                cs.date = ?
                AND cs.timeStart <= ?
                AND cs.timeEnd >= ?
                AND ce.student_id = ?
                AND ce.status = 'Approved'
            `;
            const [rows] = await pool.query(query, [today ,currentTime, currentTime, studentId]);
            // console.log("Current time:", currentTime);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    //Update Class
    async updateClass(id, courseCode, className, date, timeStart, timeEnd, classLocation ) {

        //Debugging
        console.log("Update Class ID:", id);
        console.log("Update Class Data:", { courseCode, className, date, timeStart, timeEnd, classLocation });
        
        const query = `
            UPDATE ClassSession
            SET courseCode = ?, className = ?, date = ?, timeStart = ?, timeEnd = ?, classroomId = ? 
            WHERE classId = ?
        `;
        const values = [courseCode, className, date, timeStart, timeEnd, classLocation , id];
    
        // console.log("Executing SQL:", query);
        // console.log("With values:", values);
    
        await pool.query(query, values);
        return id;
    },
    

    //Delete Class
    async deleteClass(id) {
        const query = `DELETE FROM ClassSession WHERE classId = ?`;
        await pool.query(query, [id]);
        return id;
    },

    //Lecturer get current class
    async lecturerGetCurrentClass(lecturerId) {
        try {
            const today = moment().format("YYYY-MM-DD");
            const currentTime = moment().format("HH:mm:ss");
            const query = `
            SELECT DISTINCT
                cs.classId,
                c.courseCode,
                c.courseName AS className,
                cs.date,
                cs.timeStart,
                cs.timeEnd,
                cl.classroomName AS classLocation,
                c.imageUrl,
                cr.publishStatus,
                u.name
            FROM 
                ClassSession cs
            JOIN 
                User u ON cs.lecturerId = u.externalId
            JOIN
                Course c ON cs.courseId = c.courseId
            JOIN 
                Classroom cl ON cs.classroomId = cl.classroomId
            JOIN 
                CourseEnrollment ce ON cs.courseId = ce.courseId
            LEFT JOIN 
                ClassRecording cr ON cs.classId = cr.classId
            WHERE 
                cs.date = ?
                AND cs.timeStart <= ?
                AND ADDTIME(cs.timeEnd, '01:00:00') >= ?
                AND cs.lecturerId = ?
                AND ce.status = 'Approved'
`;
            const [rows] = await pool.query(query, [today ,currentTime, currentTime, lecturerId]);
            // console.log("Current time:", currentTime);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },
};

module.exports = ClassModel;