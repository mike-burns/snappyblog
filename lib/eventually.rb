require 'web_socket'
require 'securerandom'
require 'announcer'

class ConnectionAnnouncer
  def initialize(connection_id)
    @connection_id = connection_id
  end

  def key(k)
    builder.key = k
    self
  end

  def payload(p)
    builder.payload = p
    self
  end

  def announce
    if builder.valid?
      builder.build
    else
      raise ArgumentError,
        "the announcer must have both a key and a payload"
    end
  end

  def to_json(*a)
    {'json_class' => 'ConnectionAnnouncer',
      'data' => [@connection_id]}.to_json(*a)
  end

  def as_json(*a)
    {'json_class' => 'ConnectionAnnouncer',
      'data' => [@connection_id]}.as_json(*a)
  end

  def self.json_create(o)
    new(*o['data'])
  end

  private

  def builder
    @_builder ||= ConnectionAnnouncerBuilder.new(@connection_id)
  end

  class ConnectionAnnouncerBuilder
    attr_writer :key, :payload

    def initialize(connection_id)
      @connection_id = connection_id
    end

    def valid?
      !@payload.nil? && !@key.nil?
    end

    def build
      Announcer.announce(@connection_id, [@key, @payload])
    end
  end
end


class AppropriateQueue
  def self.new
    enqueuer
  end

  def self.enqueuer=(o)
    @@enqueuer = o
  end

  def self.enqueuer
    if defined?(@@enqueuer)
      @@enqueuer
    else
      @@enqueuer = Resque
    end
  end
end

module Eventually
  def self.included(base)
    base.before_filter :set_connection_id
  end

  def eventually(class_name, *args)
    enqueuer = AppropriateQueue.new
    announcer = ConnectionAnnouncer.new(session[:connection_id])
    enqueuer.enqueue(class_name, announcer, *args)
  end

  private

  def set_connection_id
    session[:connection_id] ||= SecureRandom.hex(16)
  end
end
