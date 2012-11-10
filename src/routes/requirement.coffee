module.exports = (app) ->
  
  #create  
  app.get '/projects/:project/requirements/new', (req, res) ->
    res.render 'requirement/new'
  
  app.post '/projects/:project/requirements', (req, res) ->
    
  #delete
  app.delete '/projects/:project/requirements', (req, res) ->
    
  
  #read
  app.get '/projects/:project/requirements/:requirement', (req, res) ->
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
  
  #read
  app.get '/projects/:project/requirements/:requirement/users/:username/work', (req, res) ->
  
  #delete
  app.delete '/projects/:project/requirements/:requirement/users/:username/work', (req, res) ->