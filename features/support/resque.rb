class ImmediateQueueRunner
  def enqueue(constant, *args)
    constant.perform(*args)
  end
end

Before('@circumvent-resque') do
  @prior_enqueuer = AppropriateQueue.enqueuer
  AppropriateQueue.enqueuer = ImmediateQueueRunner.new
end

After('@circumvent-resque') do
  AppropriateQueue.enqueuer = @prior_enqueuer
end
