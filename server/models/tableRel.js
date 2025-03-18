const sequelize = require("../config/database"); // Import Sequelize instance
const User = require("./User");
const UserRole = require("./UserRole");
const UserVerification = require("./UserVerification"); // Import UserVerification

// Define relationships
User.belongsTo(UserRole, { foreignKey: "roleId", as: "role" });
UserRole.hasMany(User, { foreignKey: "roleId", as: "users" });

// Define relationship between User and UserVerification
User.hasOne(UserVerification, { foreignKey: "userId", as: "verification" });
UserVerification.belongsTo(User, { foreignKey: "userId", as: "user" });

// Export all models
const db = {
  sequelize,
  User,
  UserRole,
  UserVerification, 
};

module.exports = db; 
