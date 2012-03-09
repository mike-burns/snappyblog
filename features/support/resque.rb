class FiveSecondQueueRunner
  def enqueue(constant, *args)
    Thread.new do
      sleep 5
      constant.perform(*args)
    end
  end
end

Before('@circumvent-resque') do
  Resque.inline = true
end

After('@circumvent-resque') do
  Resque.inline = false
end

Before('@inline-resque') do
  @prior_enqueuer = AppropriateQueue.enqueuer
  AppropriateQueue.enqueuer = FiveSecondQueueRunner.new
end

After('@inline-resque') do
  AppropriateQueue.enqueuer = @prior_enqueuer
end
