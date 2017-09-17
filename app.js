var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var bodyParser = require('body-parser');

var index = require('./routes/index');
var users = require('./routes/users');
var auth = require('./routes/auth');
var organizations = require('./routes/organizations');
var recruits = require('./routes/recruits');
var passport = require('passport');
var models = require('./models');
var LocalStrategy = require('passport-local').Strategy;
var cors = require('cors')
var app = express();
app.use(cors());


app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.use(passport.initialize());

app.use(logger('dev'));

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, x-access-token");
  next();
});


passport.use(new LocalStrategy(
  function(username, password, done) {
    models.User.findOne({where: { username: username }}).then(
      function(user) {
        if (!user) { return done(null, false); }
        user.verifyPassword(password).then(res => {
          if (!res) { return done(null, false); }
          return done(null, user);
        })
      },
      function(err) {
        return done(err);
      });
  }));


app.use('/', index);
app.use('/users', users);
app.use('/auth', auth);
app.use('/organizations', organizations);
app.use('/recruits', recruits);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(express.static(path.join(__dirname, 'public')));


module.exports = app;
