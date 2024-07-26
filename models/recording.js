module.exports = (sequelize, DataTypes) => {
const Recording = sequelize.define('Recording', {
    id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true
    },
    fileName: {
        type: DataTypes.STRING,
        allowNull: false
    },
    filePath: {
        type: DataTypes.STRING,
        allowNull: false
    },
    cameraId: {
        type: DataTypes.UUID,
        allowNull: false
    }
}, {
    timestamps: true
});

return Recording;

}

