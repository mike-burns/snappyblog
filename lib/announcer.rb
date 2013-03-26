require 'web_socket'
require 'singleton'
require 'observer'

class Announcer
  include Singleton
  include Observable

  def self.announce(*args)
    instance.announce(*args)
  end

  def announce(connection_id, payload)
    changed
    notify_observers(connection_id, payload)
  end
end

class WebSocketAnnouncer
  def initialize
  end

  def update(connection_id, payload)
    # Seems unable to maintain a connection.
    client = WebSocket.new('ws://localhost:8080/')
    client.send([connection_id, payload.as_json].to_json)
  end
end

class EmailAnnouncer
  def initialize
  end

  def update(connection_id, payload)
    user = User.find_by_session_id(connection_id)
    AnnouncementEmailer.announce(user, payload).deliver
  end
end
