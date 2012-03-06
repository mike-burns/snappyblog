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

def wait_for_key(key, countdown = 10)
  if @monitor_announcer.nil?
    raise "must use @monitor-announcements to use #wait_for_key"
  end

  if countdown.zero?
    raise "The key #{key} was not announced."
  elsif !@monitor_announcer.has_announcement?(key)
    sleep 1
    wait_for_key(key, countdown-1)
  end
end
