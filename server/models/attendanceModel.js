const pool = require("../config/database").pool;

const AttendanceModel = {
    async addAttendance(classId, studentId, attendanceStatus) {
        try {
            const query = `
                INSERT INTO Attendance (classId, studentId, attendanceStatus)
                VALUES (?, ?, ?)
            `;
            const [rows] = await pool.query(query, [classId, studentId, attendanceStatus]);
            return rows;
        } catch (error) {
            // Check for duplicate entry error (MySQL error code 1062)
            if (error.code === 'ER_DUP_ENTRY') {
                const customError = new Error("Attendance already created!");
                customError.status = 409; // Conflict
                throw customError;
            }

            // Other unexpected errors
            const genericError = new Error("Error in model while adding attendance: " + error.message);
            genericError.status = 500;
            throw genericError;
        }
    },

    //Check student attendance
    async checkAttendance(classId, studentId) {
        try {
            const query = `
                SELECT attendanceStatus
                FROM Attendance
                WHERE classId = ? AND studentId = ?
            `;
            const [rows] = await pool.query(query, [classId, studentId]);
    
            // Check if a result exists and map the status
            if (rows.length > 0) {
                if(rows[0].attendanceStatus === "Absent") return "Absent";
                if(rows[0].attendanceStatus === "Present") return "Present";
            }
    
            // Default to "Absent" if no record is found
            return "Absent";
        } catch (error) {
            const genericError = new Error("Error in model while checking attendance: " + error.message);
            genericError.status = 500;
            throw genericError;
        }
    },
};

module.exports = AttendanceModel;
