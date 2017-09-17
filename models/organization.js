'use strict';
module.exports = (sequelize, DataTypes) => {
	let Organization = sequelize.define('Organization', {
    	primary_name: DataTypes.STRING,
    	secondary_name: DataTypes.STRING,
    	token_code: {
    		type: 'VARCHAR(255)',
    	}
   	}, {underscored:true});
    Organization.associate = function(models) {
    	Organization.belongsToMany(models.User, { as: 'Users', through: 'user_organization', foreignKey: 'organization_id'})
    	Organization.hasMany(models.Recruit)
    }
    return Organization;
};