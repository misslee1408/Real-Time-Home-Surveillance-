const { DataTypes } = require('sequelize');
const sequelize = require('../config/database'); //This file exports a Sequelize instance configured to connect to your PostgreSQL database.

const Camera = sequelize.define('Camera', {
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  location: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
  },
}, {
  timestamps: true,
});

module.exports = Camera;
