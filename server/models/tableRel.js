const sequelize = require("../config/database"); // ✅ Import Sequelize instance
const User = require("./User");
const UserRole = require("./UserRole");

// Define relationships
User.belongsTo(UserRole, { foreignKey: "roleId", as: "role" });
UserRole.hasMany(User, { foreignKey: "roleId", as: "users" });

const db = {
  sequelize,
  User,
  UserRole,
};

module.exports = db; // ✅ Export everything
