// Generated by CoffeeScript 1.4.0
(function() {
  var Auth, Project;

  Project = require('../models/project').Model;

  Auth = require('./auth');

  module.exports = function(app) {
    app.get('/projects/new', function(req, res) {
      return Auth.user(req, res, '/login', function() {
        return res.render('project/new');
      });
    });
    app.post('/projects', function(req, res) {
      return Auth.user(req, res, '/login', function() {
        var b, newProject;
        b = req.body;
        if (b.projectname) {
          newProject = new Project();
          newProject.name = b.projectname;
          newProject.users.push({
            username: req.user.username,
            role: 'manager'
          });
          newProject.estimation.cocomo.mode = b.mode;
          newProject.estimation.cocomo.factors.RELY = b.RELY;
          newProject.estimation.cocomo.factors.DATA = b.DATA;
          newProject.estimation.cocomo.factors.CPLX = b.CPLX;
          newProject.estimation.cocomo.factors.TIME = b.TIME;
          newProject.estimation.cocomo.factors.STOR = b.STOR;
          newProject.estimation.cocomo.factors.VIRT = b.VIRT;
          newProject.estimation.cocomo.factors.TURN = b.TURN;
          newProject.estimation.cocomo.factors.ACAP = b.ACAP;
          newProject.estimation.cocomo.factors.AEXP = b.AEXP;
          newProject.estimation.cocomo.factors.PCAP = b.PCAP;
          newProject.estimation.cocomo.factors.VEXP = b.VEXP;
          newProject.estimation.cocomo.factors.LEXP = b.LEXP;
          newProject.estimation.cocomo.factors.MODP = b.MODP;
          newProject.estimation.cocomo.factors.TOOL = b.TOOL;
          newProject.estimation.cocomo.factors.SCED = b.SCED;
          return newProject.save(function(err) {
            if (err) {
              res.flash('error', err + '');
              return res.redirect('/');
            } else {
              res.flash('success', 'Your project has been created.');
              return res.redirect('/');
            }
          });
        } else {
          res.flash('error', 'Please provide project with a name.');
          return res.redirect('/');
        }
      });
    });
    app.get('/projects/:project', function(req, res) {
      return Auth.member(req, res, '/projects', function() {
        return Project.findOne({
          'name': req.params.project
        }).exec(function(err, project) {
          if (project) {
            return res.render('project/index', {
              'project': project
            });
          } else {
            return res.redirect('/404');
          }
        });
      });
    });
    app.put('/projects/:project', function(req, res) {});
    app["delete"]('/projects', function(req, res) {
      return Auth.manager(req, res, '/projects', function() {
        return Project.findOne({
          'name': req.body.project
        }).remove(function(err) {
          return res.redirect('/projects');
        });
      });
    });
    app.post('/projects/:project/users', function(req, res) {
      return Auth.manager(req, res, '/projects/' + req.params.project, function() {
        return Project.findOne({
          'name': req.params.project
        }).exec(function(err, project) {
          project.users.push({
            username: req.body.username,
            role: req.body.role
          });
          return project.save(function(err) {
            console.log(err);
            console.log(project);
            return res.redirect('/projects/' + req.params.project);
          });
        });
      });
    });
    app.put('/projects/:project/users/:username', function(req, res) {
      return Auth.manager(req, res, '/projects/' + req.params.project, function() {
        var username;
        username = req.params.username;
        return Project.findOne({
          'name': req.params.project
        }).exec(function(err, project) {
          var count, index, user, _i, _len, _ref;
          index = -1;
          count = 0;
          _ref = project.users;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            user = _ref[_i];
            if (user.username === username) {
              index = count;
            }
            count++;
          }
          if (index !== -1) {
            project.users[index].role = req.body.role;
            return project.save(function(err) {
              return res.redirect('/projects/' + req.params.project);
            });
          } else {
            return res.redirect('/projects/' + req.params.project);
          }
        });
      });
    });
    return app["delete"]('/projects/:project/users', function(req, res) {
      return Auth.manager(req, res, '/projects/' + req.params.project, function() {
        var username;
        if (req.user.username === req.body.username) {
          res.flash('error', 'You can not remove yourself.');
          return res.redirect('/projects/' + req.params.project);
        }
        username = req.body.username;
        return Project.findOne({
          'name': req.params.project
        }).exec(function(err, project) {
          var count, index, user, _i, _len, _ref;
          index = -1;
          count = 0;
          _ref = project.users;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            user = _ref[_i];
            if (user.username === username) {
              index = count;
            }
            count++;
          }
          if (index !== -1) {
            project.users[index].remove();
            return project.save(function(err) {
              return res.redirect('/projects/' + req.params.project);
            });
          } else {
            return res.redirect('/projects/' + req.params.project);
          }
        });
      });
    });
  };

}).call(this);
