// Generated by CoffeeScript 1.4.0
(function() {
  var manager, member, user;

  manager = function(req, res, fail, cb) {
    return user(req, res, '/login', function() {
      return req.user.isManager(req.params.project, function(manager) {
        if (!manager) {
          res.flash('error', 'You are not a manager of the project.');
          return res.redirect(fail);
        } else {
          return cb();
        }
      });
    });
  };

  member = function(req, res, fail, cb) {
    return user(req, res, '/login', function() {
      return req.user.isMember(req.params.project, function(member) {
        if (!member) {
          res.flash('error', 'You are not a member of the project.');
          return res.redirect(fail);
        } else {
          return cb();
        }
      });
    });
  };

  user = function(req, res, fail, cb) {
    if (!req.user) {
      res.flash('error', 'You must be logged in.');
      return res.redirect(fail);
    } else {
      return cb();
    }
  };

  exports.user = user;

  exports.member = member;

  exports.manager = manager;

}).call(this);