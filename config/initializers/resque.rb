require 'redis'
require 'resque/server'
require 'resque/scheduler/server'
require 'active_scheduler'

host = Gem.win_platform? ? '127.0.0.1' : 'localhost'
redis = Redis.new(host: host, port: 6379)
Resque.redis = redis
Resque.redis.namespace = "resque:#{Rails.env}"

yaml_schedule    = YAML.load_file("#{Rails.root}/config/schedule.yml") || {}
wrapped_schedule = ActiveScheduler::ResqueWrapper.wrap yaml_schedule
Resque.schedule  = wrapped_schedule
