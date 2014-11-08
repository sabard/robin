var accessToken = "4c11bbd86fd64f2a86045a02197b657e";
var subscriptionKey = "b55a40bb-dcd0-4e77-9979-8030f7815911";
var baseUrl = "https://api.api.ai/v1/";

function speak(message){
  var msg = new SpeechSynthesisUtterance(message);
  window.speechSynthesis.speak(msg);
}

function showAlert(text){
  $(".alert-center").text(text);
  $(".alert-center").fadeIn();
  setTimeout(function(){
    $(".alert-center").fadeOut();
  }, 5000);
}

$(document).ready(function() {
  $(".mic").addClass('animated pulse');
  $("#input").keypress(function(event) {
    if (event.which == 13) {
      event.preventDefault();
      send();
    }
  });
  $("#rec").click(function(event) {
    switchRecognition();
  });
});

var recognition;

function startRecognition() {
  $(".mic").removeClass('animated flash');
  $(".mic").addClass('animated rotateIn');
  recognition = new webkitSpeechRecognition();
  recognition.onstart = function(event) {
    updateRec();
  };
  recognition.onresult = function(event) {
    var text = "";
      for (var i = event.resultIndex; i < event.results.length; ++i) {
        text += event.results[i][0].transcript;
      }
      setInput(text);
    stopRecognition();
  };
  recognition.onend = function() {
    stopRecognition();
     $(".mic").removeClass('animated rotateIn');
    $(".mic").addClass('animated flash');
  };
  recognition.lang = "en-US";
  recognition.start();
}

function stopRecognition() {
  if (recognition) {
    recognition.stop();
    recognition = null;
  }
  updateRec();
}

function switchRecognition() {
  if (recognition) {
    stopRecognition();
  } else {
    startRecognition();
  }
}

function setInput(text) {
  $("#input").val(text);
  if (text.search("help") != -1){
    speak("Plea for help recognized. Contacting local authorities and a friend for help.");
    showAlert("Plea for help recognized. Contacting local authorities and a friend for help.");
    $.ajax({
      url: 'trigger_event/accident',
      type:   'GET',
      success: function (html) {
        setTimeout(function(){
          speak("Your friend and authorities have been contacted.");
          showAlert("Your friend and authorities have been contacted..");
        }, 500);
      },
      error: function (response) {
      }
    });
  }
  else if (text.search("hospital") != -1 && (text.search("where") != -1 || text.search("location") != -1 || text.search("find") != -1)){
    speak("Searching for the nearest hospital");
    showAlert("Searching for the nearest hospital");
  }
  else{
    speak("I'm not sure how to process your request");
  }
  send();
}

function updateRec() {
  $(".status").text(recognition ? "Stop when done" : "Speak when ready");
}

function send() {
  var text = $("#input").val();
  $.ajax({
    type: "POST",
    url: baseUrl + "query/",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    headers: {
      "Authorization": "Bearer " + accessToken,
      "ocp-apim-subscription-key": subscriptionKey
    },
    data: JSON.stringify({ q: text, lang: "en" }),

    success: function(data) {
      setResponse(JSON.stringify(data, undefined, 2));
      console.log(JSON.stringify(data, undefined, 2));
    },
    error: function() {
      setResponse("Internal Server Error");
    }
  });
  setResponse("Loading...");
}

function setResponse(val) {
  $("#response").text(val);
}