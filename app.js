
/**
 * Module dependencies.
 */

var express = require('express')
  , http = require('http')
  , path = require('path')
  , passport = require('passport')
  , LocalStrategy = require('passport-local').Strategy
  , passportConfig = require('./passport-config')
  , routesConfig = require('./routes-config')
  , mongoose = require('mongoose');

var app = express();

mongoose.connect('mongodb://nodejitsu:a0d9eb7a816c8aa13dd1841baf9c6a2b@alex.mongohq.com:10086/nodejitsudb284536924124');

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  app.use(express.session({ secret: '28FFB9ABAB6B0961799D52E171D2E06352B9A0BB8679708A42C98B20AC6680A6' }));
  app.use(passport.initialize());
  app.use(passport.session());  
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

passportConfig(app);
routesConfig(app);

http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});
