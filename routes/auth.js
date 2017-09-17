var express = require('express');
var router = express.Router();
var models = require('../models');
var bcrypt = require('bcrypt');
var passport = require('passport');
var jwt = require('jsonwebtoken');
/* GET home page. */



router.post('/signup', async function(req, res, next) {
	let plain_pass = req.body.password;
	console.log(req.body)
	let encrypted_pass = await bcrypt.hash(plain_pass, 12)
	let saved_user = await models.User.create(
		{
			first_name: req.body.first_name, 
			last_name: req.body.last_name, 
			username: req.body.username, 
			password: encrypted_pass
		});
	
	res.json(saved_user);
});

router.post('/login', passport.authenticate('local', {session: false}),
	function(req, res) {
		let user = req.user.toJSON()
		delete user['password']
		var token = jwt.sign(req.user.get('id'), 'bobthebuilder');
		return res.json({user: user, token: token})
	});

module.exports = router;
