const pool = require("../config/database").pool;

const AttendanceModel = {
    async addAttendance(classId, studentId, attendanceStatus , timeStamp) {
        // Validate input parameters
        if (!classId || !studentId || !attendanceStatus || !timeStamp) {
            const missingParamError = new Error("Missing required parameters: classId, studentId, attendanceStatus , timeStamp");
            missingParamError.status = 400; // Bad Request
            throw missingParamError;
        }

        //Debugging log
        // console.log("Adding attendance with parameters:", {
        //     classId,
        //     studentId,
        //     attendanceStatus,
        //     timeStamp
        // });

        try {
            const query = `
                INSERT INTO Attendance (classId, studentId, attendanceStatus , timeStamp)
                VALUES (?, ?, ? , ?)
            `;
            const [rows] = await pool.query(query, [classId, studentId, attendanceStatus , timeStamp]);
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

    // Function to generate attendance report
    async generateAttendanceReport(classId) {
        try {
            const query = `
                SELECT 
                a.studentId, 
                u.name AS studentName,
                u.userEmail AS studentEmail,
                a.attendanceStatus, 
                a.timeStamp AS attendanceTime,
                co.courseCode AS courseCode,
                co.courseName AS className,
                us.name AS lecturerName,
                c.date AS classDate,
                c.timeStart AS classStartTime,
                c.timeEnd AS classEndTime,
                c.classLocation AS classLocation

                FROM Attendance a
                JOIN User u ON a.studentId = u.externalId 
                JOIN ClassSession c ON a.classId = c.classId
                JOIN User us ON c.lecturerId = us.externalId
                JOIN Course co ON c.courseId = co.courseId
                WHERE a.classId = ?
            `;
            const [rows] = await pool.query(query, [classId]);

            // Check if any records were found
            if (rows.length === 0) {
                const noDataError = new Error("No attendance records found for this class.");
                noDataError.status = 404; // Not Found
                throw noDataError;
            }

            return rows;
        } catch (error) {
            const genericError = new Error("Error in model while generating attendance report: " + error.message);
            genericError.status = 500;
            throw genericError;
        }
    }
};

module.exports = AttendanceModel;
