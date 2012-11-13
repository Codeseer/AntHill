exports.user = (req, res, next) ->
  res.locals.user = req.user
  next()
  
exports.flash = (req, res, next) ->
  messages = req.session.messages || req.session.messages = []
  res.flash = (type, text) ->
    messages.push 
      'type': type
      'text': text
  res.locals.messages = messages
  next()