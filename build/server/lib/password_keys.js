// Generated by CoffeeScript 1.9.3
var Client, PasswordKeys;

Client = require("request-json").JsonClient;

PasswordKeys = (function() {
  function PasswordKeys() {
    this.client = new Client("http://localhost:9101/");
    this.name = process.env.NAME;
    this.token = process.env.TOKEN;
    if (process.env.NODE_ENV === "production" || process.env.NODE_ENV === "test") {
      this.client.setBasicAuth(this.name, this.token);
    }
  }

  PasswordKeys.prototype.initializeKeys = function(pwd, callback) {
    return this.client.post("accounts/password/", {
      password: pwd
    }, (function(_this) {
      return function(err, res, body) {
        if (err) {
          return callback(err);
        } else {
          return callback();
        }
      };
    })(this));
  };

  PasswordKeys.prototype.updateKeys = function(pwd, callback) {
    return this.client.put("accounts/password/", {
      password: pwd
    }, (function(_this) {
      return function(err, res, body) {
        if (err) {
          return callback(err);
        } else {
          return callback();
        }
      };
    })(this));
  };

  PasswordKeys.prototype.resetKeys = function(callback) {
    return this.client.del("accounts/reset/", (function(_this) {
      return function(err, res, body) {
        if (err) {
          return callback(err);
        } else {
          return callback();
        }
      };
    })(this));
  };

  return PasswordKeys;

})();

module.exports = new PasswordKeys();
