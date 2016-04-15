// Generated by CoffeeScript 1.10.0
var User;

User = require('../models/user');

module.exports.getAuthType = function(next) {
  return User.first(function(err, user) {
    if (user) {
      if (err) {
        return next(err);
      } else if (user.authType) {
        return next(null, user.authType);
      } else {
        return next(null, null);
      }
    } else {
      return next(null, null);
    }
  });
};
