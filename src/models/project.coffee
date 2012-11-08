mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
Requirement = require './requirement'

Project = new Schema
  name:
    type: String,
    unqiue: true,
    required: true
  requirements: [Requirement.Schema]


exports.Model = mongoose.model 'project', Project
exports.Schema = Project