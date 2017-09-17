'use strict';
module.exports = (sequelize, DataTypes) => {
	let Comment = sequelize.define('Comment', {
    	text: DataTypes.TEXT,

   	}, {underscored:true});
    Comment.associate = function(models) {
    	Comment.belongsTo(models.Comment, { as: 'Parent'})
        Comment.belongsTo(models.Recruit)
        Comment.belongsTo(models.User)
        Comment.belongsTo(models.Organization)
        Comment.hasMany(models.Vote)
    }
    return Comment;
};