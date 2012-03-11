class FakeAnnouncer
  def key(key)
    @key = key
    self
  end

  def payload(payload)
    @payload = payload
    self
  end

  def announce
    @announced = true
  end

  def has_announced_key_and_payload?(key, payload)
    has_announced_key?(key) && @payload == payload
  end

  def has_announced_key?(key)
    @announced && @key == key
  end
end

RSpec::Matchers.define :have_announced do |key|
  chain :payload do |payload|
    @payload = payload
  end

  match do |fake_announcer|
    if @payload
      fake_announcer.has_announced_key_and_payload?(key, @payload)
    else
      fake_announcer.has_announced_key?(key)
    end
  end
end
