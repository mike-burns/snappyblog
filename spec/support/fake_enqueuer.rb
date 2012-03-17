class FakeEnqueuer
  def initialize
    @queue = []
  end

  def enqueue(constant, announcer, data)
    stringified_data = data.inject({}) do |hash,(key,value)|
      hash.merge(key.to_s => value)
    end

    @queue << [constant, stringified_data]
  end

  def queue_contains?(element)
    @queue.include?(element)
  end
end

RSpec::Matchers.define :have_enqueued do |constant|
  chain :with do |data|
    stringified_data = data.inject({}) do |hash,(key,value)|
      hash.merge(key.to_s => value)
    end

    @data = stringified_data
  end

  match do |fake_queue|
    fake_queue.queue_contains?([constant, @data])
  end
end
