passport = require('passport')

module.exports = (app)->
  app.get '/', (req, res) ->
    if(!req.user)
      res.redirect '/login'
    else
      res.redirect '/projects'
  
  app.get '/login', (req, res) ->
    res.render 'login'
  
  app.post '/login', passport.authenticate( 'local',
    successRedirect: '/'
    failureRedirect: '/login')
  
  app.get '/logout', (req, res) ->
    req.logOut()
    res.redirect '/'