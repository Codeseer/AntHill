User = require('../models/user').Model
passport = require('passport')
module.exports = (app)->
  app.get '/', (req, res) ->
    if(!req.user)
      res.redirect '/login'
    else
      res.redirect '/user'
  
  app.get '/login', (req, res) ->
    res.render 'login'
  
  app.post '/login', passport.authenticate( 'local',
    successRedirect: '/'
    failureRedirect: '/login')
  
  app.get '/logout', (req, res) ->
    req.logOut()
    res.redirect '/'
  
  app.get '/register', (req, res) ->
    res.render 'register' 
  
  app.post '/register', (req, res) ->
    b = req.body
    if(b.username && b.password)
      if(b.password != b.passwordConfirm)
        res.flash 'error', 'Passwords are not the same.'
        res.redirect '/register'
      else
        #try to add to database
        newUser = new User()
        newUser.username = b.username
        newUser.password = b.password
        newUser.save (err) ->
          if err
            res.flash 'error', err
            res.redirect '/register'
          else
            res.flash 'success', 'You have been successfully registered.'
            res.redirect '/'