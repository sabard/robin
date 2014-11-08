// var Accel = require('ui/accel');
// var UI = require('ui');
// var Vector2 = require('vector2');
// var ajax = require('ajax');

// function sendAjax() {
//   ajax(
//     {
//       url: 'http://5d1dfef5.ngrok.com/trigger_event/accident',
//       type: 'json'
//     },
//     function(data) {
//       console.log('data ' + data);
//     },
//     function(error) {
//       console.log('The ajax request failed: ' + error);
//     }
//   );
// }

// sendAjax();

// var pastAccel = [];
// Accel.init();

// function getAccel(previousAccel, previousTime, previousTextLog, i) {

//   Accel.peek(function(e) {
//     var currentAccel = Math.sqrt(e.accel.x*e.accel.x + e.accel.y*e.accel.y + e.accel.z*e.accel.z);
//     var currentTime = e.accel.time;

// //     console.log(currentAccel + " " + currentTime);
//     var textLog = new UI.Text({
//       position: new Vector2(0, 0),
//       size: new Vector2(144, 168),
//       text: parseInt(currentAccel - previousAccel).toString()
//     });

//     if (i < 10) {
//       pastAccel[i] = [];
//       pastAccel[i][0] = parseInt(currentAccel - previousAccel);
//       pastAccel[i][1] = currentTime;
//     }
//     else {
//       pastAccel.shift();
//       pastAccel[9] = [];
//       pastAccel[9][0] = parseInt(currentAccel - previousAccel);
//       pastAccel[9][1] = currentTime;
//     }

//     console.log(pastAccel);

//     var wind = new UI.Window();
// //     wind.remove(previousTextLog);
//     wind.add(textLog);
//     wind.show();

//     previousAccel = currentAccel;
//     previousTime = currentTime;
//     previousTextLog = textLog;
//     i++;
//   });

//   setTimeout(function() { getAccel(previousAccel, previousTime, previousTextLog, i); }, 500);
// }

// getAccel(1000, 0, 0, 0);