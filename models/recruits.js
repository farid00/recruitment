'use strict';
module.exports = (sequelize, DataTypes) => {
  var Recruit = sequelize.define('Recruit', {
    first_name: DataTypes.STRING,
    middle_name: DataTypes.STRING,
    last_name: DataTypes.STRING
  },
  {underscored: true});

  Recruit.associate = function(models) {
    Recruit.belongsTo(models.Organization)
    Recruit.belongsTo(models.User)
    Recruit.belongsToMany(models.Comment, {as: 'Comments', through: 'comment', foreignKey: 'recruit_id'})
  }
  return Recruit;
};