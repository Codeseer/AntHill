mongoose = require 'mongoose'
Schema = mongoose.Schema

Requirement = new Schema  

exports.Model = mongoose.model 'requirement', Requirement
exports.Schema = Requirement