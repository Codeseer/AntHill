mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
Requirement = require './requirement'

roles = ['manager','member']#manager has CRUD member has UD

ProjectUser = new Schema
  username: 
    type: String
    required: true
  role:
    type: String
    enum: roles

Project = new Schema
  name:
    type: String
    unique: true
    required: true
  description: String
  users:[ProjectUser]
  estimation:
    cocomo:
      mode:
        type: String
        default: 'organic'
      factors:
        RELY: Number
        DATA: Number
        CPLX: Number
        TIME: Number
        STOR: Number
        VIRT: Number
        TURN: Number
        ACAP: Number
        AEXP: Number
        PCAP: Number
        VEXP: Number
        LEXP: Number
        MODP: Number
        TOOL: Number
        SCED: Number
    FP:
      primary:
        Input: Number
        Output: Number
        Inquiry: Number
        File: Number
        Interface: Number
      influence:
        dataCommunications: Number
        distributedData: Number
        performance: Number
        hardware: Number
        transactionRate: Number
        onlineDataEntry: Number
        endUserEfficiency: Number
        onlineUpdate: Number
        computation: Number
        reusability: Number
        installation: Number
        operation: Number
        portability: Number
        maintainability: Number
  requirements: [Requirement.Schema]
  
  
Project.virtual('estimation.loc').get () ->
  loc = 0
  for requirement in this.requirements
    loc += requirement.estimation.loc
  return loc
  
Project.virtual('actual.loc').get () ->
  loc = 0
  for requirement in this.requirements
    loc += requirement.actual.loc
  return loc  
  
Project.virtual('estimation.time').get () ->
  time = 0
  for requirement in this.requirements
    time += requirement.estimation.time
  return time
  
Project.virtual('actual.time').get () ->
  time = 0
  for requirement in this.requirements
    time += requirement.actual.time
  return time

Project.virtual('estimation.cocomo.effort').get () ->
  switch this.esitimation.cocomo.mode
    when 'organic'
      a = 2.4
      b = 1.05
    when 'semi-detached'
      a = 3.0
      b = 1.12
    when 'embedded'
      a = 3.6
      b = 1.2
  f = this.estimation.cocomo.factors
  prodF = f.RELY*f.DATA*f.CPLX*f.TIME*f.STOR*f.VIRT*f.TURN*f.ACAP*f.AEXP*f.PCAP*f.VEXP*f.LEXP*f.MODP*f.TOOL*f.SCED
  return a * Math.pow(this.estimation.loc/1000,b) * prodF
  
Project.virtual('estimation.cocomo.time').get () ->
  switch this.esitimation.cocomo.mode
    when 'organic'
      c = 2.5
      d = 0.38
    when 'semi-detached'
      c = 2.5
      d = 0.38
    when 'embedded'
      c = 2.5
      d = 0.38
  return a * Math.pow(this.estimation.cocomo.effort,d)

exports.Model = mongoose.model 'project', Project
exports.Schema = Project