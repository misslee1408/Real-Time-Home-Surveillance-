const { Sequelize } = require('sequelize');

const sequelize = new Sequelize('home-security', 'postgres', 'floxyleon2', {
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
