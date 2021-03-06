// Generated by CoffeeScript 1.4.0
(function() {
  var ProjectUser, Schema, mongoose, roles;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  roles = ['manager', 'member'];

  ProjectUser = new Schema({
    user: {
      type: String,
      required: true
    },
    project: String({
      type: String,
      required: true
    }),
    role: {
      type: String,
      "enum": roles,
      lowercase: true
    }
  });

  ProjectUser.index({
    user: 1
  }, project(1));

  exports.Model = mongoose.model('ProjectUser', ProjectUser);

  exports.Schema = ProjectUser;

}).call(this);
