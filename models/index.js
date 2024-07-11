const fs = require('fs');
const path = require('path');
const { Sequelize, DataTypes } = require('sequelize');

const sequelize = new Sequelize({
  dialect: 'postgres',
  database: 'home-security',
  username: 'postgres',
  password: 'liana',
  host: 'localhost',
  port: 5432, // or your PostgreSQL port
  logging: false, // disable logging SQL queries
});

const models = {};

// Read all model files from the current directory
fs
  .readdirSync(__dirname)
  .filter(file => file !== 'index.js') // Exclude index.js itself
  .forEach(file => {
    const modelDefiner = require(path.join(__dirname, file));
    const model = new modelDefiner(sequelize, DataTypes);
    models[model.name] = model;
  });

// Apply associations if needed
Object.keys(models).forEach(modelName => {
  if ('associate' in models[modelName]) {
    models[modelName].associate(models);
  }
});

models.sequelize = sequelize;
models.Sequelize = Sequelize;

module.exports = models;
