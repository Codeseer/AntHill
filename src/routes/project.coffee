Project = require('../models/project').Model
Auth = require './auth'


module.exports = (app) ->

  #Create
  app.get '/projects/new', (req, res) ->
    Auth.user req, res, '/login', ()-> 
      res.render 'project/new'
    
  app.post '/projects',  (req, res) ->
    Auth.user req, res, '/login', ()->    
      b = req.body
      if(b.projectname)
        newProject = new Project()
        newProject.name = b.projectname
        newProject.users.push
          username: req.user.username
          role: 'manager'
        newProject.estimation.cocomo.mode = b.mode
        newProject.estimation.cocomo.factors.RELY = b.RELY
        newProject.estimation.cocomo.factors.DATA = b.DATA
        newProject.estimation.cocomo.factors.CPLX = b.CPLX
        newProject.estimation.cocomo.factors.TIME = b.TIME
        newProject.estimation.cocomo.factors.STOR = b.STOR
        newProject.estimation.cocomo.factors.VIRT = b.VIRT
        newProject.estimation.cocomo.factors.TURN = b.TURN
        newProject.estimation.cocomo.factors.ACAP = b.ACAP
        newProject.estimation.cocomo.factors.AEXP = b.AEXP
        newProject.estimation.cocomo.factors.PCAP = b.PCAP
        newProject.estimation.cocomo.factors.VEXP = b.VEXP
        newProject.estimation.cocomo.factors.LEXP = b.LEXP
        newProject.estimation.cocomo.factors.MODP = b.MODP
        newProject.estimation.cocomo.factors.TOOL = b.TOOL
        newProject.estimation.cocomo.factors.SCED = b.SCED

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
  app.get '/projects/:project', (req, res) ->
    Auth.member req, res, '/projects', () ->
      Project.findOne('name': req.params.project).exec (err, project)->
        if project
          res.render 'project/index', 'project': project
        else
          res.redirect '/404'
  
  # update    
  app.put '/projects/:project', (req, res) ->
    #TODO
  
  #delete
  app.delete '/projects', (req, res) ->
    Auth.manager req, res, '/projects', () ->
      Project.findOne('name': req.body.project).remove (err) ->
        return res.redirect '/projects'
        
  #####ROUTES FOR project users
  #create
  app.post '/projects/:project/users', (req, res) ->
    Auth.manager req, res, '/projects/'+req.params.project, () ->
      Project.findOne('name': req.params.project).exec (err, project) ->
        project.users.push
          username: req.body.username
          role: req.body.role
        project.save (err) ->
          console.log err
          console.log project
          return res.redirect '/projects/'+req.params.project
  
  #update
  app.put '/projects/:project/users/:username', (req, res) ->
    Auth.manager req, res, '/projects/'+req.params.project, () ->
      username = req.params.username
      Project.findOne('name': req.params.project).exec (err, project) ->
        index = -1
        count = 0
        for user in project.users
          index = count if user.username == username
          count++; 
        if index != -1
          project.users[index].role = req.body.role
          project.save (err) ->
            return res.redirect '/projects/'+req.params.project
        else
          return res.redirect '/projects/'+req.params.project  
  
  #delete
  app.delete '/projects/:project/users', (req, res) ->
    Auth.manager req, res, '/projects/'+req.params.project, () ->
      if req.user.username == req.body.username
        res.flash 'error', 'You can not remove yourself.'
        return res.redirect '/projects/'+req.params.project
      username = req.body.username
      Project.findOne('name': req.params.project).exec (err, project) ->
        index = -1
        count = 0
        for user in project.users
          index = count if user.username == username
          count++; 
        if index != -1
            project.users[index].remove()
            project.save (err) ->
              return res.redirect '/projects/'+req.params.project
        else
          return res.redirect '/projects/'+req.params.project