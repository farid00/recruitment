var express = require('express');
var router = express.Router();
var models = require('../models');
var jwt = require('jsonwebtoken')
var getUser = require('../public/javascripts/get_user')

router.use(getUser);

/* GET users listing. */
router.get('/:id', async function(req, res, next) {
	let user = await models.User.findById(
		req.params.id, 
		{attributes: {exclude: ['password']}
	});
  res.json(user);
});

router.get('/', async function(req, res, next) {
  	res.json(req.user);
});

router.patch('/', async function(req, res, next) {
	let user = req.user;
	let newUser = await user.update({organization_id: req.body.organization_id})
	return res.json({success: true, data: {organization_id: req.body.organization_id}})
});



module.exports = router;
