'use strict';
module.exports = (sequelize, DataTypes) => {
	let Vote = sequelize.define('Vote', {
    	value: DataTypes.INTEGER,
   	}, {underscored:true});
    Vote.associate = function(models) {
    	Vote.belongsTo(models.User)

    }
    return Vote;
};