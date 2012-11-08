User = require('../models/user').Model

exports.index = (req, res) ->
  if(!req.user)
    res.redirect '/login'
  else
    res.redirect '/users'

#handles the get request
exports.login = (req, res) ->
  res.render 'login'

exports.logout = (req, res) ->
  req.logOut()
  req.redirect '/'

exports.register = (req, res) ->
  res.render 'register'

exports.registerPost = (req, res) ->
  b = req.body
  if(b.username && b.password)
    if(b.password != b.passwordConfirm)
      return res.render 'register', message: 'Passwords are not the same.'
    else
      #try to add to database
      newUser = new User()
      newUser.username = b.username
      newUser.password = b.password
      newUser.save (err) ->
        if err
          return res.render 'register', message: err
        else
          return res.render 'index', message: 'You have been successfully registered.'
  else
    return res.render 'register', message: 'username and password are required'

