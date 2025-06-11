const pool = require("../config/database").pool;

const SuperAdminModel = {
    async getAllUsers () {
        try {
            const query = 
            `
            SELECT 
                u.userId,
                u.name,
                u.userName,
                u.userEmail,
                u.roleId,
                u.externalId,
                r.roleName,
                u.is_approved AS status
                
            FROM User u
            JOIN UserRole r ON u.roleId = r.roleId    
            WHERE u.is_approved != 'Pending'
            `;
            const [rows] = await pool.query(query);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    //Get user by id
    async getUserById (userId) {
        try {
            const query = 
            `
            SELECT 
                u.userId,
                u.name,
                u.userName,
                u.userEmail,
                u.roleId,
                u.externalId,
                r.roleName,
                u.is_approved AS status
                
            FROM User u
            JOIN UserRole r ON u.roleId = r.roleId    
            WHERE u.userId = ?
            `;
            const [rows] = await pool.query(query, [userId]);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    //Retrieve all pending approvals
    async getAllPendingApprovals () {
        try {
            const query = 
            `
            SELECT 
                u.userId,
                u.name,
                u.userName,
                u.userEmail,
                u.roleId,
                u.externalId,
                r.roleName
                
            FROM User u
            JOIN UserRole r ON u.roleId = r.roleId    
            WHERE u.is_approved = "Pending"
            `;
            const [rows] = await pool.query(query);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    //Update approval status
    async updateApprovalStatus (userId, status) {
        try {
            const query = 
            `
            UPDATE User
            SET is_approved = ?
            WHERE userId = ?
            `;
            const [rows] = await pool.query(query, [status,userId]);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    //Delete user
    async deleteUser (userId) {
        try {
            const query = 
            `
            DELETE FROM User
            WHERE userId = ?
            `;
            const [rows] = await pool.query(query, [userId]);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    //Disable user
    async disableUser (userId , status) {
        try {
            const query = 
            `
            UPDATE User
            SET is_approved = ?
            WHERE userId = ?
            `;
            const [rows] = await pool.query(query, [status , userId]);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    }
};

module.exports = SuperAdminModel;