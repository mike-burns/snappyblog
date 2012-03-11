class NoopJob
  def initialize(queue_name)
    @queue = queue_name
  end

  def self.perform
  end
end
