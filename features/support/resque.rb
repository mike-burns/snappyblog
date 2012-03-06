class ImmediateQueueRunner
  def enqueue(constant, *args)
    constant.perform(*args)
  end
end

class FiveSecondQueueRunner
  def enqueue(constant, *args)
    Thread.new do
      sleep 5
      constant.perform(*args)
    end
  end
end

Before('@circumvent-resque') do
  @prior_enqueuer = AppropriateQueue.enqueuer
  AppropriateQueue.enqueuer = ImmediateQueueRunner.new
end

After('@circumvent-resque') do
  AppropriateQueue.enqueuer = @prior_enqueuer
end

Before('@inline-resque') do
  @prior_enqueuer = AppropriateQueue.enqueuer
  AppropriateQueue.enqueuer = FiveSecondQueueRunner.new
end

After('@inline-resque') do
  AppropriateQueue.enqueuer = @prior_enqueuer
end
