require 'announcer'

class MonitorAnnouncer
  def initialize
    @announcements = []
  end

  def update(connection_id, payload)
    @announcements.unshift([connection_id, payload])
  end

  def has_announcement?(key)
    @announcements.any? do |announcement|
      announcement[1].try(:[], 0) == key
    end
  end

  def recently_keyed_on(key)
    @announcements.detect do |announcement|
      announcement[1].try(:[], 0) == key
    end
  end
end

Before('@monitor-announcements') do
  @monitor_announcer = MonitorAnnouncer.new
  Announcer.instance.add_observer(@monitor_announcer)
end

After('@monitor-announcements') do
  Announcer.instance.delete_observer(@monitor_announcer)
end
