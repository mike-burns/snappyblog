require 'announcer'

Before('@announce') do
  @web_socket_announcer = WebSocketAnnouncer.new
  Announcer.instance.add_observer(@web_socket_announcer)
end

After('@announce') do
  Announcer.instance.delete_observer(@web_socket_announcer)
end
