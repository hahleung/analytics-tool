module Gateway
  class Persistence
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

    def get_table(table)
      @storage.scan_each(match: "#{table}:*").map do |element|
        @storage.hgetall(element)
      end
    end
  end
end