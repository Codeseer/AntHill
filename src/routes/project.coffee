Project = require('../models/project').Model

module.exports = (app) ->

  #Create
  app.get '/projects/new', (req, res) ->
    res.render 'project/new'
    
  app.post '/projects',  (req, res) ->
    if !req.user
      res.flash 'error', 'You must be logged in to create a new project.'
      return res.redirect '/login'
    
    b = req.body
    if(b.projectname)
      newProject = new Project()
      newProject.name = b.projectname
      newProject.users.push
        username: req.user.username
        role: 'manager'        
      newProject.save (err) ->
        if err
          res.flash 'error', err+''
          return res.redirect '/' 
        else     
          res.flash 'success', 'Your project has been created.'
          return res.redirect '/'
    else
      res.flash 'error', 'Please provide project with a name.'
      return res.redirect '/'  
  
  #Read  
  app.get '/projects/:name', (req, res) ->
    Project.findOne(name: req.params.name).exec (err, project)->
      if project
        res.render 'project/index', 'project': project
      else
        res.redirect '/404'
  
  # update    
  app.put '/projects/:name', (req, res) ->
    #TODO
  
  #delete
  app.delete '/projects', (req, res) ->
    req.user.isManager req.body.name, (manager) ->
      return res.redirect '/projects' if !manager
    Project.findOne(name: req.body.name).remove (err) ->
      return res.redirect '/projects'
    
  #####ROUTES FOR project users
  #create
  app.post '/projects/:name/users', (req, res) ->
    req.user.isManager req.params.name, (manager) ->
      if !manager
        res.flash 'error', 'You are not the manager'
        return res.redirect '/projects/'+req.params.name 
      Project.findOne(name: req.params.name).exec (err, project) ->
        project.users.push
          username: req.body.username
          role: req.body.role
        project.save (err) ->
          console.log err
          console.log project
          return res.redirect '/projects/'+req.params.name
  
  #update
  app.put '/projects/:name/users/:username', (req, res) ->
    req.user.isManager req.params.name, (manager) ->
      if !manager
        res.flash 'error', 'You are not the manager'
        return res.redirect '/projects/'+req.params.name 
      username = req.params.username
      Project.findOne(name: req.params.name).exec (err, project) ->
        index = -1
        count = 0
        for user in project.users
          index = count if user.username == username
          count++; 
        if index != -1
          project.users[index].role = req.body.role
          project.save (err) ->
            return res.redirect '/projects/'+req.params.name
        else
          return res.redirect '/projects/'+req.params.name  
  
  #delete
  app.delete '/projects/:name/users', (req, res) ->
    req.user.isManager req.params.name, (manager) ->
      if !manager
        res.flash 'error', 'You are not the manager'
        return res.redirect '/projects/'+req.params.name
    if req.user.username == req.body.username
      res.flash 'error', 'You can not remove yourself.'
      return res.redirect '/projects/'+req.params.name
    username = req.body.username
    Project.findOne(name: req.params.name).exec (err, project) ->
      index = -1
      count = 0
      for user in project.users
        index = count if user.username == username
        count++; 
      if index != -1
          project.users[index].remove()
          project.save (err) ->
            return res.redirect '/projects/'+req.params.name
      else
        return res.redirect '/projects/'+req.params.name