# https://github.com/defunkt/resque/issues/306
if defined?(Resque)
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
end
