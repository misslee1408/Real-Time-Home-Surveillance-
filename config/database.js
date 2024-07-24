
// config/database.js
const { Sequelize } = require('sequelize');

const sequelize = new Sequelize('database', 'username', 'password', {
  host: 'localhost',
  dialect: 'postgres', // or 'sqlite', 'postgres', 'mariadb', etc.
});

module.exports = sequelize;





// const { Sequelize } = require('sequelize');
// const config = require('./config.json')['development'];


// const sequelize = new Sequelize(config.database, config.username, config.password, {
//   host: config.host,
//   dialect: config.dialect,
//   logging: false // Disable logging SQL queries

// });

// module.exports = sequelize;
