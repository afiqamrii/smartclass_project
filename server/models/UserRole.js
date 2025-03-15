const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");


const UserRole = sequelize.define("UserRole", {
    roleId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      allowNull: false,
    },
    roleName: {
      type: DataTypes.STRING(30), // Matches VARCHAR(30)
      allowNull: false,
    },
  }, {
    tableName: "UserRole",
    timestamps: false,
  });
  
  module.exports = UserRole;
  