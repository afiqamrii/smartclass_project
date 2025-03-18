const { DataTypes } = require("sequelize");
const sequelize = require("../config/database").sequelize;

const UserVerification = sequelize.define("UserVerification", {
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: "User",
      key: "userId",
    },
  },
  uniqueString: {
    type: DataTypes.STRING(255),
    allowNull: false,
  },
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  expiresAt: {
    type: DataTypes.DATE,
    allowNull: false,
  },
}, {
  tableName: "UserVerification",
  timestamps: false, 
});

module.exports = UserVerification;