mongoose = require 'mongoose'
Schema = mongoose.Schema
Project = require('./project').Model

User = new Schema
  username:
    type: String
    unique: true
    required: true
  password: String
  projects: [String]

# password validation logic
User.methods.validPassword = (password, done) ->
  if this.password == password
    done null, this
  else
    done null, false, message: 'Invalid Password'

# retrive an array of projects from the database
User.methods.getProjects = (cb) ->
  Project.find(
    name:
      $in: 
        this.projects
    ).exec (err, projects)->
      if err
        cb err
      else
        cb null, projects


exports.Model = mongoose.model 'user', User
exports.Schema = User