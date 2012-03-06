function ws_register(connectionId, handler) {
  if (typeof MozWebSocket == "undefined") {
    ws = new WebSocket("ws://localhost:8080/");
  } else {
    ws = new MozWebSocket("ws://localhost:8080/");
  }

  ws.onmessage = function(evt) {
    var j = JSON.parse(evt.data);
    handler(j);
  };

  ws.onclose = function() { };

  ws.onopen = function() {
    ws.send('["register_as", "' + connectionId + '"]');
  };
}
