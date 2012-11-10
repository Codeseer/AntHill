module.exports = (app) ->
  require('./routes') app
  require('./routes/user') app
  require('./routes/project') app