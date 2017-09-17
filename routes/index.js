var express = require('express');
var router = express.Router();
var models = require('../models');

/* GET home page. */
router.get('/', async function(req, res, next) {
	res.json({fdsaf:'afdsa'});
});

module.exports = router;
