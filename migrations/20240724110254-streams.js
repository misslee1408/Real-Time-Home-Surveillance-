'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('streams', {
      id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        primaryKey: true,
        allowNull: false
      },
      cameraId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Cameras',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      streamUrl: {
        type: Sequelize.STRING,
        allowNull: false
      },
      isActive: {
        type: Sequelize.BOOLEAN,
        defaultValue: false
      },
      createdAt: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.NOW
      },
      updatedAt: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.NOW
      }
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('streams');
  }
};
