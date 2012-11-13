mongoose = require 'mongoose'
Schema = mongoose.Schema

status = ['unstarted', 'design', 'development', 'testing', 'completed', 'discarded']

Work = new Schema
  desc: String
  date: Date start time
  time: Number

RequirementUser = new Schema
  username: String
  commitment:#time commiment
    type: Number
    default: 0
  work: [Work]

Requirement = new Schema
  name: String
  description: String
  users:[RequirementUser]
  status:
    type: String
    enum: status
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
Requirement.virtual('actual.start').get () ->
  earliestDate = null;
  for user in this.users
    for task in user.work
      if earliestDate
        if task.date < earliestDate
          earliestDate = task.date
      else
        earliestDate = task.date
  return earliestDate

exports.Model = mongoose.model 'requirement', Requirement
exports.Schema = Requirement