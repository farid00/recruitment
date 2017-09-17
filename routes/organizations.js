var express = require('express');
var router = express.Router();
var models = require('../models');
var passport = require('passport');
var jwt = require('jsonwebtoken');
var models = require('../models')
var getUser = require('../public/javascripts/get_user')
var crypto = require('crypto')
router.use(getUser);

router.post('/', async function(req, res, next) {
	var token = crypto.randomBytes(48).toString('base64')

	let organization = await models.Organization.create({
		primary_name: req.body.primary_name,
		secondary_name: req.body.secondary_name,
		token: token
	});

	await organization.addUser(req.decoded)

  	res.json(organization);
});

router.get('/', async function(req, res, next) {
	let organizations = await models.Organization.findAll({
		include: [{
			model: models.User,
			as: 'Users',
			through: {
				attributes: ['first_name'],
				where: {user_id: req.decoded}
			},
			required: true
		}]
	})
	res.json(organizations);
});

router.post('/join-organization/', async function(req, res){
	let user = req.user
	let organization = await models.Organization.findOne({
		where: {token_code: req.body.token_code}
	})
	await organization.addUser(user);
	res.json(organization);
}) 

module.exports = router