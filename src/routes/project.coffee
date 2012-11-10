Project = require('../models/project').Model

module.exports = (app) ->
  
    #Read
  app.get '/projects/:name', (req, res) ->
    Project.findOne(name: req.params.name).exec 
    (err, project)->
      if !err
        res.render 'project/index', 'project': project
      else
        res.redirect '/404'
  
  #Create
  app.get '/project/new', (req, res) ->
    res.render 'project/new'
  
  app.post '/project/new',  (req, res) ->
    if !req.user
      res.flash 'error', 'You must be logged in to create a new project.'
      return res.redirect '/login'
    
    b = req.body
    if(b.projectname)
      newProject = new Project()
      newProject.name = b.projectname
      newProject.save (err) ->
        if !err
          req.user.projects.push b.projectname
          req.user.save (err) ->            
            res.flash 'success', 'Your project has been created.'
            res.redirect '/user'
        else
          Project.findOne(name: b.projectname).exec 
          (err, prj) ->
            if prj
              res.flash 'error', 'A project with that name already exists.'
              res.redirect req.originalUrl
    else
      res.flash 'error', 'Please provide project with a name.'
      res.redirect req.originalUrl
  

  
  