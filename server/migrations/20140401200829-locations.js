var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
  db.runSql("create table locations (id serial, description varchar, lat decimal, long decimal, position geometry(Point, 4326));", callback);
};

exports.down = function(db, callback) {
  db.runSql("drop table locations;", callback);
};
