// creating details of the user #flonicah phiri
const { DataTypes } = require('sequelize');
const sequelize = require('../config/database'); //This file exports a Sequelize instance configured to connect to your PostgreSQL database.

const User = sequelize.define('User', {
  username: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
  },
}, {
  timestamps: true,
});

module.exports = User;
