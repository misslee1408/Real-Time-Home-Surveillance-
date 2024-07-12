const fs = require('fs');
const path = require('path');
const { Sequelize, DataTypes } = require('sequelize');

const sequelize = new Sequelize({
  dialect: 'postgres',
  database: 'home-security',
  username: 'postgres',
  password: 'floxyleon2',
  host: 'localhost',
  port: 5432, //
  logging: false, // disable logging SQL queries
});

const models = {};

// Read all model files in the directory and import them
fs
  .readdirSync(__dirname)
  .filter(file => file !== 'index.js') // Exclude this file (index.js) 
  .forEach(file => {
    const modelDefiner = require(path.join(__dirname, file));
    const model = new modelDefiner(sequelize, DataTypes); // Call the function to define the model
    models[model.name] = model;
  });

// Associate models if needed
Object.keys(models).forEach(modelName => {
  if ('associate' in models[modelName]) {
     models[modelName].associate(models);
  }
  });
models.sequelize = sequelize;
models.Sequelize = Sequelize;

module.exports = models;
