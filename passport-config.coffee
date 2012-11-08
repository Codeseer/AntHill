User = require('./models/user').Model
passport = require('passport')
LocalStrategy = require('passport-local').Strategy

module.exports = (app) ->
  app.use(passport.initialize());
  app.use(passport.session()); 

  passport.serializeUser (user, done) ->
    done null, user.username


  passport.deserializeUser (username, done) ->
    User.findOne username, (err, user) ->
      done err, user

  passport.use 'local', new LocalStrategy (username, password, done) ->
      User.findOne 'username': username, (err, user) ->
        if err 
          done err
        else if !user
          done null, false, message: 'Uknown User'
        else
          user.validPassword password, done