routes = require('./routes')
user = require('./routes/user')
project = require('./routes/project')  
passport = require('passport')

module.exports = (app) ->
  app.get '/', routes.index
  app.get '/login', routes.login
  
  #on post login redirect to users home page.
  app.post '/login', 
    passport.authenticate 'local',
      successRedirect: '/'
      failureRedirect: '/login'
      failureFlash: true

  app.get '/register', routes.register
  app.post '/register', routes.registerPost

  app.get '/user', user.index

  app.get '/projects', project.index