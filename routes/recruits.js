var express = require('express');
var router = express.Router();
var models = require('../models');
var passport = require('passport');
var jwt = require('jsonwebtoken');
var models = require('../models');
var getUser = require('../public/javascripts/get_user')
var commentRouter = require('./comments')

router.use(getUser)
router.use('/:recruitId/comments', commentRouter);

router.get('/', async function(req, res){ 
	let recruits = await models.Recruit.findAll({
		where: { organization_id: req.user.organization_id }
	});
	res.json(recruits);
});

router.post('/', async function(req, res) {
	if (!req.user.organization_id) {
		res.json({
				success: false,
				message: 'An active organization must be set to create recruits'
				});
	}
	let recruit = await models.Recruit.create({
							first_name: req.body.first_name,
							last_name: req.body.last_name,
							organization_id: req.user.organization_id,
							user_id: req.user.id
						});
	res.json(recruit);
});

router.get('/:recruitId', async function(req, res){
	let recruit = await models.Recruit.findOne({
		where: { id: req.params.recruitId, organization_id: req.user.organization_id },
		attributes: {exclude: ['organization_id']}
	});
	res.json(recruit);
})
module.exports = router