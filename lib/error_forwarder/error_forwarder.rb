require 'em-websocket'
require 'json'
require 'active_support/core_ext/object'

EventMachine.run do
  @channel = EM::Channel.new

  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
    ws.onopen do
      connection_id = -1

      sid = @channel.subscribe do |msg|
        relay = JSON.parse(msg)
        recipient_id, payload = relay
        if connection_id.to_i == recipient_id.to_i
          ws.send payload.to_json
        end
      end

      ws.onclose do
        @channel.unsubscribe(sid)
      end

      ws.onmessage do |msg|
        parsed = JSON.parse(msg)
        if parsed.first == "register_as"
          connection_id = parsed[1]
        else
          @channel.push(msg)
        end
      end

      ws.onerror {|err| p err }
    end
  end
end
