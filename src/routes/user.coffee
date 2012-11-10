passport = require('passport')

module.exports = (app) ->
  
  app.get '/user', (req, res) ->
    return res.redirect '/login' if !req.user
    #If the fuction gets to here then a user is logged in
    u = req.user
    #get all the projects for this user and render user home page
    u.getProjects (err, user_projects) ->
      console.log user_projects
      if !err        
        res.render 'user/index', 
          projects: user_projects
          username: u.username
      else
        res.render 'user/index'

