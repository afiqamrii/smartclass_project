const jwt = require("jsonwebtoken");

const superAdminAuth = (req, res, next) => {
    try {
        const token = req.headers["x-auth-token"];
        if (!token) {
            return res.status(401).json({ message: "No auth token, access denied!" });
        }

        const verified = jwt.verify(token, "passwordKey");

        // console.log("Verified token:", verified); // ✅ Check role

        // Allow both string and number formats for backward compatibility
        if (!verified || (verified.role !== "superadmin" && verified.role !== 5)) {
            return res.status(403).json({ message: "Access denied! Superadmin only." });
        }

        req.user = { id: verified.id, role: verified.role };
        req.token = token;
        next();
    } catch (err) {
        console.error("JWT Error:", err.message);
        res.status(500).json({ error: err.message });
    }
};

module.exports = superAdminAuth;
