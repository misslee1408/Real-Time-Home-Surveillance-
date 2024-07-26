module.exports = (sequelize, DataTypes) => {
    const Stream = sequelize.define('Stream', {
        cameraId: {
            type: DataTypes.INTEGER,
            allowNull: false,
            references: {
                model: 'Cameras',
                key: 'id'
            }
        },
        streamUrl: {
            type: DataTypes.STRING,
            allowNull: false
        },
        isActive: {
            type: DataTypes.BOOLEAN,
            defaultValue: false
        }
    }, {
        tableName: 'streams',
        timestamps: false
    });

    return Stream;
};
