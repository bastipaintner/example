var io = require('socket.io').listen(5001)
var redis = require('redis');
var winston = require('winston');

var store = redis.createClient();
var sub = redis.createClient();
var logfile = '/var/www/subway_tube/log/socketio.log'

var logger = new (winston.Logger)({
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({
      filename: '../log/socketio.log',
      json:false,
      maxsize: 1000000
   })
  ],
  exceptionHandlers: [
    new winston.transports.File({
      filename: '../log/socketio.log',
      json:false,
      maxsize: 1000000
    })
  ]
});

sub.subscribe("__keyevent@0__:expired");

sub.on("message", function(channel, msg){
  io.emit('offline', msg);
  logger.info("offline: " + msg);
});

store.on("error", function(err) {
    logger.error("Error connecting to redis", err);
});

logger.info('Service startet!...');

function pushImages() {
  var time = getTimeStamp();
  var stream_hash = "stream_" + time;
  var trains_arr = [];

  store.set("time_stream", time);

  store.hgetall(stream_hash, function(err, msg){
    io.emit('stream', msg);
    msg = msg ? msg : "";
    for (var train in msg) {
      if(train != 'time_stamp' && train != 'time_readable' && train != 'name') {
        trains_arr.push(train);
        store.exists(train, function(err, message){
          var train_id = this["args"].toString();
          if (message == 0) {
            store.set(train_id, 1);
            io.emit('online', train_id);
            logger.info("set " + train_id);
          }
          store.expire(train_id, 10);
        });
      }
    }
    store.set("trains_online", trains_arr.toString());
    store.del(stream_hash);
  });
}

function getTimeStamp() {
  var year, month, day, hours, minutes, seconds, time;
  time = new Date();
  time.setSeconds(time.getSeconds() - 10);
  year = time.getFullYear();
  month = getFullDatePart(time.getMonth() + 1);
  day = getFullDatePart(time.getDate());
  hours = getFullDatePart(time.getHours());
  minutes = getFullDatePart(time.getMinutes());
  seconds = getFullDatePart(time.getSeconds());
  time = parseInt(year + month + day + hours + minutes + seconds);
  return (time - (time % 2)).toString();
}

function getFullDatePart(val) {
  val = val.toString();
  return (val < 10) ? "0" + val : val;
}

setInterval (pushImages, 2000);
