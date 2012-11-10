module.exports = (app)->
  app.get '/404', (req, res) ->
    res.render 'error/404'