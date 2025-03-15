const { DataTypes } = require("sequelize");
const sequelize = require("../config/database").sequelize; 

const User = sequelize.define("User", {
  userId: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true, // Ensure this if userId is auto-incremented
    allowNull: false,
  },
  userName: {
    type: DataTypes.STRING(50), // Matches VARCHAR(15)
    allowNull: false,
  },
  userEmail: {
    type: DataTypes.STRING(255), // Matches VARCHAR(20)
    allowNull: false,
    unique: true, // Ensures no duplicate emails
  },
  userPassword: {
    type: DataTypes.STRING(255), // Stores hashed passwords (bcrypt)
    allowNull: false,
  },
  roleId: {
    type: DataTypes.INTEGER, // Foreign Key (UserRole)
    allowNull: false,
    references: {
      model: "UserRole",
      key: "roleId",
    },
  },
}, {
  tableName: "User",
  timestamps: false, // Disable createdAt/updatedAt
});

module.exports = User;
