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

///////////////////////////////////////////////////////

// var data = [[48,2358517179],[-12,2358517879],[6,2358518423],[-310,2358518971],[0,2358519527],[2,2358520096],[-13,2358520676],[10,2358521265],[310,2358521861],[20,2358522979]];
// var THRESHOLD = 100;

// function detectCrash(array){
//   var timeArray = utcToTime(array);
//   var time_mapped = timeArray.map(function(value){return value[1]});
//   var mapped = array.map(function(value){return value[0]});
//   var abs_mapped = array.map(function(value){return Math.abs(value[0])});
//   var stdv = standardDeviation(abs_mapped);
//   if (stdv < THRESHOLD){
//     return false;
//   }
//   else {
//     var max = Math.max.apply(Math, mapped);
//     var min = Math.min.apply(Math, mapped);
//     if (max / (max + min) > 0.9 && Math.abs(mapped.indexOf(max) - mapped.indexOf(min)) <= 2){
//       return true;
//     }
//     return false;
//   }
// }

// function utcToTime(array){
//   return array.map(function(value){
//     var d = new Date();
//     d.setUTCMilliseconds(value[1]);
//     return [value[0], d];
//   });
// }

// function standardDeviation(values){
//   var avg = average(values);
  
//   var squareDiffs = values.map(function(value){
//     var diff = value - avg;
//     var sqrDiff = diff * diff;
//     return sqrDiff;
//   });
  
//   var avgSquareDiff = average(squareDiffs);
 
//   var stdDev = Math.sqrt(avgSquareDiff);
//   return stdDev;
// }
 
// function average(data){
//   var sum = data.reduce(function(sum, value){
//     return sum + value;
//   }, 0);
 
//   var avg = sum / data.length;
//   return avg;
// }

// detectCrash(data);