const { Sequelize } = require('sequelize');
<<<<<<< HEAD
// #flonicah
const sequelize = new Sequelize('home-security', 'postgres', 'floxyleon2', {
=======

const sequelize = new Sequelize('home-security', 'postgres', 'liana', {
>>>>>>> cd4b515ecd7eb5faacbcdffbd4574e776db1719a
  host: 'localhost',
  dialect: 'postgres',
});

sequelize.authenticate() //method used to verify the connection.
  .then(() => {
    console.log('Connection has been established successfully.');
  })
  .catch((error) => {
    console.error('Unable to connect to the database:', error);
  });

module.exports = sequelize;
