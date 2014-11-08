    

    var pusher = new Pusher(pusher_key);
    var channel = pusher.subscribe('events');
    channel.bind('accident', function(data) {
      showAlert(data.message);
    });