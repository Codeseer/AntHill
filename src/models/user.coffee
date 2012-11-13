mongoose = require 'mongoose'
Schema = mongoose.Schema
Project = require('./project').Model

User = new Schema
  username:
    type: String
    unique: true
    required: true
  password: String

# password validation logic
User.methods.validPassword = (password, done) ->
  if this.password == password
    done null, this
  else
    done null, false, message: 'Invalid Password'

# retrive an array of projects from the database
User.methods.getProjects = (cb) ->
  Project.find('users.username': this.username).exec (err, projects)->
      if err
        cb err
      else
        cb null, projects

User.methods.isManager = (project, cb) ->  
  username = this.username
  Project.findOne('name': project).exec (err, project) ->
    index = -1
    count = 0
    for user in project.users
      index = count if user.username == username
      count++;    
    if(index != -1)
      cb project.users[index].role == 'manager'
    else
      cb false

User.methods.isMember = (project, cb) ->  
  username = this.username
  Project.findOne('name': project).exec (err, project) ->
    index = -1
    count = 0
    for user in project.users
      index = count if user.username == username
      count++;
    cb index != -1

exports.Model = mongoose.model 'user', User
exports.Schema = User