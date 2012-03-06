require 'web_socket'
require 'securerandom'

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
    enqueuer.enqueue(class_name, session[:connection_id], *args)
  end

  private

  def set_connection_id
    session[:connection_id] ||= SecureRandom.hex(16)
  end
end
