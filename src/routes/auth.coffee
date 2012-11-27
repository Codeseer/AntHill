manager = (req, res, fail, cb) ->
  user req, res, '/login', ()->
    req.user.isManager req.param('project'), (manager) ->
      if !manager
        res.flash 'error', 'You are not a manager of the project.'
        res.redirect fail
      else
        cb()

member = (req, res, fail, cb) ->
  user req, res, '/login', ()->
    console.log req.param('project')
    req.user.isMember req.param('project'), (member) ->
      if !member
        res.flash 'error', 'You are not a member of the project.'
        res.redirect fail
      else
        cb()
      
user = (req, res, fail, cb) ->    
    if !req.user
      res.flash 'error', 'You must be logged in.'
      return res.redirect fail
    else
      cb()

exports.user = user
exports.member = member
exports.manager = manager