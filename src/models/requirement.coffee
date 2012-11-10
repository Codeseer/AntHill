mongoose = require 'mongoose'
Schema = mongoose.Schema

Requirement = new Schema
  name: String
  completion: Date
  

exports.Model = mongoose.model 'requirement', Requirement
exports.Schema = Requirement