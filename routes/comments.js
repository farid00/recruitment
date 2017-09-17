var express = require('express');
var router = express.Router({mergeParams:true});
var models = require('../models');
var passport = require('passport');
var jwt = require('jsonwebtoken');
var models = require('../models');
var getUser = require('../public/javascripts/get_user')

//Get comments for one recruit
router.get('/', async function(req, res){
	let organization = await req.user.getOrganization()
	let securityCheck = await organization.hasRecruit(req.params.recruitId)
	if (!securityCheck) {
		res.json({success:false, message: 'recruit does not exist or you do not have permission to view'});
	}
	let comments = await models.Comment.findAll({
		where: {recruit_id: req.params.recruitId},
		raw: true,
		group:['Comment.id'],
/*		organization: {organization_id: req.user.organization_id},*/

		include: [{
			model:models.Vote,
			group: ['Votes.value'],
			attributes: ['value', [models.sequelize.fn('COUNT', models.sequelize.col('Votes.id')), 'items']],
		}]
	});
	res.json(comments);
});

//Post comment for one recruit
router.post('/', async function(req, res){
	let params ={}
	parentComment = req.body.parent_id || false

	
	
	params = {

		user_id: req.user.id,
		organization_id: req.user.organization_id,
		recruit_id: req.body.recruit_id,
		text: req.body.text,
	}

	if(parentComment) {
		let parentCheck = await models.Comment.findOne({
			where: {id: parentComment,
					recruit_id: req.body.recruit_id}
		})
		if(parentCheck) {
			params['parent_id'] = parentComment
		}
	}

	let comment = await models.Comment.create(params);
	res.json([comment])
})
module.exports = router