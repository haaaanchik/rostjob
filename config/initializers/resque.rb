require 'redis'
require 'resque/server'
require 'resque/scheduler/server'
require 'active_scheduler'

redis = Redis.new(host: "localhost", port: 6379)
Resque.redis = redis

yaml_schedule    = YAML.load_file("#{Rails.root}/config/schedule.yml") || {}
wrapped_schedule = ActiveScheduler::ResqueWrapper.wrap yaml_schedule
Resque.schedule  = wrapped_schedule
