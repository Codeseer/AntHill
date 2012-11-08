exports.index = (req, res) ->
  return res.redirect '/login' if !req.user
  #If the fuction gets to here then a user is logged in

  #make things easy and set current user to 'u'
  u = req.user

  #get all the projects for this user and render user home page
  u.getProjects (err, user_projects) ->
    req.render 'user/index', 
      projects: user_projects
      username: u.username

