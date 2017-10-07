module Gateway
  class Persistence
    attr_accessor :storage
    MAX_AGE = 'max_age'.freeze
    MAX_AGE_DURATION = Figaro.env.max_age_seconds

    def initialize
      @storage = Redis.new
    end

    def set(table, id, field, value)
      key = [table, id].join(':')
      @storage.hset(key, field, value)
      @storage.expire(key, MAX_AGE_DURATION)
    end

    def set_cache
      @storage.set(MAX_AGE, MAX_AGE_DURATION)
      @storage.expire(MAX_AGE, MAX_AGE_DURATION)
    end

    def is_cache_outdated?
      @storage.ttl(MAX_AGE) == -2
    end
  end
end