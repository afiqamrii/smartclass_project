const attendanceService = require("../services/attendanceService");
const PDFDocument = require('pdfkit');
const fs = require('fs');
const path = require('path');

exports.addAttendance = async (req, res) => {
    // Get the current UTC time
    const currentDate = new Date();

    // Format the date directly in 'Asia/Kuala_Lumpur' time zone
    const timeStamp = currentDate.toLocaleString('en-US', {
        timeZone: 'Asia/Kuala_Lumpur', // This does the UTC+8 conversion
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: 'numeric',
        minute: '2-digit',
        second: '2-digit',
        hour12: true
    });

    console.log('Formatted timestamp:', timeStamp);

    // Add it to request body
    req.body.timeStamp = timeStamp;
    
    try {
        const addAttendance = req.body;
        console.log("Received add attendance request:", addAttendance);

        const result = await attendanceService.addAttendance(addAttendance);
        res.status(200).json({ Status_Code: 200, message: "Class Add Attendance successfully", classId: result.classId });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(400).json({ message: error.message });
    }
};

exports.checkAttendance = async (req, res) => {
    try {
        const checkAttendance = req.params;
        const result = await attendanceService.checkAttendance(checkAttendance);
        res.status(200).json({ attendanceStatus : result.attendanceStatus });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(400).json({ message: error.message });
    }
};

//Fnction to generate attendance report
exports.generateAttendanceReport = async (req, res) => {
    try {
        const classId = req.params.classId;
        console.log("Generating attendance report for classId:", classId);

        const report = await attendanceService.generateAttendanceReport(classId);
        res.status(200).json({ Status_Code: 200, message: "Attendance report generated successfully", report });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(400).json({ message: error.message });
    }
};

// Helper to convert "HH:mm:ss" → "h:mm AM/PM"
const formatTimeReadable = (timeString) => {
    if (!timeString) return 'Invalid Time';

    const [hour, minute, second] = timeString.split(':').map(Number);
    if (isNaN(hour) || isNaN(minute)) return 'Invalid Time';

    const date = new Date(2000, 0, 1, hour, minute, second || 0);
    return date.toLocaleTimeString('en-US', {
        hour: 'numeric',
        minute: '2-digit',
        hour12: true,
    });
};

// Function to generate attendance report in PDF format
exports.generateAttendanceReportPDF = async (req, res) => {
    try {
        const classId = req.params.classId;
        const report = await attendanceService.generateAttendanceReport(classId);

        if (!report || report.length === 0) {
            return res.status(404).json({ message: 'No data found' });
        }

        const sampleData = report[0];
        const generatedAt = new Date().toLocaleString();

        const doc = new PDFDocument({ margin: 40, size: 'A4' });
        const fileName = `attendance-report-class-${classId}.pdf`;

        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', `attachment; filename="${fileName}"`);

        doc.pipe(res);

        // ----- HEADER -----
        const logoPath = path.join(__dirname, '../assets/logo.png');
        if (fs.existsSync(logoPath)) {
            doc.image(logoPath, 40, 20, { width: 80 });
        }

        doc
            .fontSize(20)
            .fillColor('#1f2937')
            .font('Helvetica-Bold')
            .text('Attendance Report', 130, 40, { align: 'left' });

        doc
            .fontSize(12)
            .fillColor('#4b5563')
            .text(`Class: ${sampleData.className} (${sampleData.courseCode})`, 130, 65)
            .text(`Lecturer: ${sampleData.lecturerName}`, 130, 80)
            .text(`Date: ${sampleData.classDate}`, 130, 95)
            .text(`Time: ${formatTimeReadable(sampleData.classStartTime)} - ${formatTimeReadable(sampleData.classEndTime)}`, 130, 110)
            .text(`Location: ${sampleData.classLocation}`, 130, 125);

        doc.moveDown(3);

        // ----- TABLE HEADER -----
        const tableTop = 170;
        const itemHeight = 25;

        const headers = [
            { label: 'No.', x: 40, width: 20 },
            { label: 'Student Name', x: 75, width: 150 },
            { label: 'Email', x: 230, width: 140 },
            { label: 'Status', x: 375, width: 80 },
            { label: 'Time', x: 460, width: 150 },
        ];

        doc.rect(40, tableTop, 520, itemHeight).fill('#4f46e5').stroke();
        doc.fillColor('white').font('Helvetica-Bold').fontSize(12);

        headers.forEach(h => {
            doc.text(h.label, h.x + 5, tableTop + 7, { width: h.width, align: 'left' });
        });

        // ----- TABLE BODY -----
        let y = tableTop + itemHeight;
        doc.font('Helvetica').fontSize(10);

        report.forEach((row, i) => {
            const isEven = i % 2 === 0;
            doc.rect(40, y, 520, itemHeight).fill(isEven ? '#f3f4f6' : '#ffffff');

            doc
                .fillColor('#111827')
                .text(i + 1, 45, y + 7, { width: 25 })
                .text(row.studentName, 80, y + 7, { width: 145 })
                .text(row.studentEmail, 235, y + 7, { width: 135 })
                .fillColor(row.attendanceStatus === 'Present' ? 'green' : 'red')
                .text(row.attendanceStatus, 380, y + 7, { width: 75 })
                .fillColor('#111827')
                .text(row.attendanceTime, 465, y + 7, { width: 100 });

            y += itemHeight;

            if (y > 750) {
                doc.addPage();
                y = 40;
            }
        });


        // ----- FOOTER -----
        doc
            .fontSize(10)
            .fillColor('#6b7280')
            .text(`Report generated on: ${generatedAt}`, 40, 780, { align: 'right' });

        doc.end();
    } catch (error) {
        console.error("PDF Controller Error:", error);
        res.status(500).json({ message: error.message });
    }
};

//Register student faces
exports.registerStudentFaces = async (req, res) => {
    try {
        if (!req.params.studentId) {
            return res.status(400).json({ message: "Student ID is required" });
        }
        if (!req.file) {
            return res.status(400).json({ message: "Image is required" });
        }

        const studentId = req.params.studentId;
        const result = await attendanceService.registerStudentFaces(studentId, req.file.path);

        res.status(200).json(result);
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).json({ message: error.message || "Internal Server Error" });
    }
};

//Verify student faces
exports.verifyStudentFaces = async (req, res) => {
    try {
        if (!req.params.studentId) {
            return res.status(400).json({ message: "Student ID is required" });
        }
        if (!req.file) {
            return res.status(400).json({ message: "Image is required" });
        }

        const studentId = req.params.studentId;
        const classId = req.params.classId;

        //Call service
        const result = await attendanceService.verifyStudentFaces(studentId, req.file.path, classId);

        res.status(200).json(result);
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).json({ message: error.message || "Internal Server Error" });
    }
};


