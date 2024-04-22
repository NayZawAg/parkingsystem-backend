# RedisHelpers
module RedisHelpers
  extend ActiveSupport::Concern

  def redis
    @redis ||= Redis.new(host: Settings['redis_host'], port: Settings['redis_port'])
  end
end
