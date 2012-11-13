Project = require('./models/project').Model

module.exports = (app) ->
  require('./routes') app
  require('./routes/user') app
  require('./routes/project') app
  require('./routes/requirement') app
  
  app.param 'project', (req, res, next, name) ->
    Project.findOne('name': name).exec (err, project) ->
      res.locals.project = req.project = project if !err
      next()
      
  app.param 'requirement', (req, res, next, name) ->
    if typeof res.locals.project != 'undefined'
      for requirement in res.locals.project.requirements
        res.locals.requirement = req.requirement = requirement if requirement.name = name
    next()