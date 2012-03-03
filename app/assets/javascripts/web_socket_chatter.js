function ws_register(connectionId, handler) {
  ws = new WebSocket("ws://localhost:8080/");

  ws.onmessage = function(evt) {
    var j = JSON.parse(evt.data);
    handler(j);
  };

  ws.onclose = function() { console.log("closed"); };

  ws.onopen = function() {
    console.log("connected");
    ws.send('["register_as", "' + connectionId + '"]');
  };
}
