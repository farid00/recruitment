var express = require('express');
var router = express.Router();
var models = require('../../models');
var passport = require('passport');
var jwt = require('jsonwebtoken');
var models = require('../../models');

function getUser(req, res, next) {
  var token = req.body.token || req.query.token || req.headers['x-access-token'];
  if (req.method == 'OPTIONS') {
    next();
  } else if (token) {
    jwt.verify(token, 'bobthebuilder', function(err, decoded) {
      if (err) {
        return res.json({success: false, message: 'Failed to authenticate token'})

      } else {
        req.decoded = decoded;
        models.User.findById(decoded).then(
          function(user) {
            if (!user) { return res.json({success: false, message: 'Failed to authenticate user in associated with token'}) }
            req.user = user
            next();
          }
        )
      }
    });
  } else {
    return res.status(403).send({
      success: false,
      message: 'No token provided'
    })
  }
};

module.exports = getUser