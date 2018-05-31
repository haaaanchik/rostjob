require 'redis'
require 'redis/objects'

$redis = Redis.new(url: Rails.application.config_for(:redis)["redis"]["host"])
Redis::Objects.redis = $redis
