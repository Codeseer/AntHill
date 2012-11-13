User = require('../models/user').Model

module.exports = (app) ->
  
  #create
  app.get '/register', (req, res) ->
    res.render 'user/new' 
  
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
    
  app.get '/projects', (req, res) ->
    return res.redirect '/login' if !req.user
    #If the fuction gets to here then a user is logged in
    u = req.user
    #get all the projects for this user and render user home page
    u.getProjects (err, user_projects) ->
      if !err        
        res.render 'user/index', 
          projects: user_projects
          username: u.username
      else
        res.render 'user/index'

