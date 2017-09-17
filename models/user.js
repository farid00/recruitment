'use strict';
var bcrypt = require('bcrypt');
var models = require('../models');
module.exports = (sequelize, DataTypes) => {
  var User =  sequelize.define('User', {
    first_name: DataTypes.STRING,
    last_name: DataTypes.STRING,
    password: DataTypes.STRING,
    username: DataTypes.STRING,
  }, 
  {underscored: true});

  User.prototype.verifyPassword = function(password) {
  	return bcrypt.compare(password, this.password)	
  };

  User.associate = function(models) {
    User.belongsToMany(models.Organization, {as: 'Organizations', through: 'user_organization', foreignKey:'user_id'})
    User.belongsTo(models.Organization, {as: 'Organization'})
    User.belongsToMany(models.Recruit, {as: 'Comments', through: 'comment', foreignKey: 'user_id'})
  };
  return User
};