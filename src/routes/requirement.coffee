Auth = require './auth'
Project = require('../models/project').Model
module.exports = (app) ->
  
  #create  
  app.get '/projects/:project/requirements/new', (req, res) ->
    Auth.manager req, res, '/projects/'+req.params.project, () ->
      res.render 'requirement/new'
  
  app.post '/projects/:project/requirements', (req, res) ->
    Auth.manager req, res, '/projects/'+req.params.project, () ->
      reqUsers = []
      if req.body.users instanceof Array
        for user in req.body.users
          reqUsers.push username: user
      else
        reqUsers.push username: req.body.users
      
      req.project.requirements.push
        name: req.body.name
        description: req.body.description
        estimation:
          loc: req.body.loc
          FP: req.body.FP
          date:
            start: req.body.start
            end: req.body.end
          time: req.body.time
        users: reqUsers
      
      req.project.save (err) ->
        if !err
          res.flash 'success', 'New requirement added.'
          res.redirect '/projects/'+req.params.project
        else
          res.flash 'error', err
          res.redirect '/projects/'+req.params.project
    
  #delete
  app.delete '/projects/:project/requirements', (req, res) ->
  
  
  #read
  app.get '/projects/:project/requirements/:requirement', (req, res) ->
    Auth.member req, res, '/projects/'+req.params.project, () ->
      res.render 'requirement/index'
  #update
  
  app.get '/projects/:project/requirements/:requirement/edit', (req, res) ->
  
  ####REQUIREMENT USERS
  
  #CREATE
  app.post '/projects/:project/requirements/:requirement/users', (req, res)->
  
  #read
  app.get '/projects/:project/requirements/:requirement/users', (req, res) ->
  app.get '/projects/:project/requirements/:requirement/user/:username', (req, res) ->   
    
  #update
  app.put '/projects/:project/requirements/:requirement/users/:username', (req, res) ->
  
  #delete
  app.delete '/projects/:project/requirements/:requirement/users', (req, res) ->
  
  
  ####REQUIREMENT USER Work
  
  #CREATE
  app.post '/projects/:project/requirements/:requirement/users/:username/work', (req, res)->
    Auth.member req, res, '/projects/'+req.params.project, () ->
      reqUser = null
      for reqUserTmp in req.requirement.users
        reqUser = reqUserTmp if reqUserTmp.username = req.params.username
      reqUser.work.push
        desc: req.body.description
        date: req.body.date
        time: req.body.time
      req.project.save (err) ->
        if !err
          res.flash 'success', 'Work added to requirement.'
          res.redirect '/projects/'+req.params.project+'/requirements/'+req.params.requirement
        else
          res.flash 'error', err.toString()
          res.redirect '/projects/'+req.params.project+'/requirements/'+req.params.requirement
  #delete
  app.delete '/projects/:project/requirements/:requirement/users/:username/work', (req, res) ->