require 'em-websocket'
require 'json'
require 'active_support/core_ext/object'

def debug(msg)
  $stderr.puts msg if ENV['VERBOSE'] == '1'
end

EventMachine.run do
  @channel = EM::Channel.new

  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
    ws.onopen do
      connection_id = "-1"

      sid = @channel.subscribe do |msg|
        relay = JSON.parse(msg, :create_additions => false)
        recipient_id, payload = relay
        debug "received the message #{payload.inspect} for #{recipient_id.inspect}"
        debug "I am #{connection_id.inspect}"
        if connection_id == recipient_id
          ws.send payload.to_json
        end
      end

      ws.onclose do
        debug "closing the connection"
        debug "unsubscribing from channel #{sid.inspect}"
        @channel.unsubscribe(sid)
      end

      ws.onmessage do |msg|
        debug "received the message: #{msg.inspect}"
        parsed = JSON.parse(msg, :create_additions => false)
        if parsed.first == "register_as"
          connection_id = parsed[1]
          debug "registered as #{connection_id.inspect}"
        else
          debug "sending the message to the channel"
          @channel.push(msg)
        end
      end

      ws.onerror {|err| p err }
    end

  end
  debug "server started"
end
