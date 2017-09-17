'use strict';
module.exports = function(sequelize, DataTypes) {
  var user_organization = sequelize.define('user_organization', {
  },{underscored:true});
  return user_organization;
};