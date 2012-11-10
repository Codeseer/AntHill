mongoose = require 'mongoose'
Schema = mongoose.Schema

Work = new Schema
  desc: String
  date: Date
  time: Number

RequirementUser = new Schema
  username: String
  commitment: Number #time commiment
  work: [Work]

Requirement = new Schema
  name: String
  description: String
  users:[RequirementUser]
  estimation:
    loc: Number
    FP: Number
    date:
      start: Date
      end: Date
    time: Number
  actual:
    loc: Number
    date:
      start: Date
      end: Date
      
Requirement.virtual('actual.time').get () ->
  time = 0
  for user in this.users
    for task in user.work
      time += task.time
  return time

exports.Model = mongoose.model 'requirement', Requirement
exports.Schema = Requirement