const { DataTypes } = require("sequelize");
const sequelize = require("../config/database").sequelize;

const User = sequelize.define("User", {
  userId: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    allowNull: false,
  },
  userName: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
  name:{
    type: DataTypes.STRING(255),
    allowNull: true,
  },
  userEmail: {
    type: DataTypes.STRING(255),
    allowNull: false,
    unique: true,
  },
  userPassword: {
    type: DataTypes.STRING(255),
    allowNull: false,
  },
  roleId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: "UserRole",
      key: "roleId",
    },
  },
  verified: {
    type: DataTypes.BOOLEAN,
    defaultValue: false, // Default: not verified
    allowNull: false,
  },
  is_approved: {
    type: DataTypes.BOOLEAN,
    defaultValue: false, // Default: not approved
    allowNull: false,
  },
  externalId: {
    type: DataTypes.STRING(45),
    allowNull: true,
  },
  user_picture_url: {
    type: DataTypes.STRING(255),
    allowNull: true, // Allow null for optional profile images
  },
}, {
  tableName: "User",
  timestamps: false, // Disable createdAt/updatedAt
});

module.exports = User;
