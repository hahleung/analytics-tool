module Orchestrator
  class Maestro
    TOTAL_SPEND = 'total_spend'
    AVERAGE_SPEND = 'average_spend'
    MOST_LOYAL = 'most_loyal'
    HIGHEST_VALUE = 'highest_value'
    MOST_SOLD = 'most_sold'
    COMMANDS_WITH_EMAIL = [TOTAL_SPEND, AVERAGE_SPEND]
    COMMANDS = [HIGHEST_VALUE, MOST_LOYAL, MOST_SOLD]

    private_class_method :new

    def self.call(inputs)
      new(inputs).call
    end

    def call
      command, email = check_inputs
      check_cache

      case command
      when TOTAL_SPEND
        logger.info Model::User.get_total_spend(email, store)
      when AVERAGE_SPEND
        logger.info Model::User.get_average_spend(email, store)
      when HIGHEST_VALUE
        logger.info Service::User.highest_value(store)
      when MOST_LOYAL
        logger.info Service::User.most_loyal(store)
      when MOST_SOLD
        logger.info Service::Purchase.most_sold(store)
      end 
    end

    private

    def check_inputs
      raise logger.warn('Unexpected number of inputs') if inputs.size > 2 || inputs.size.zero?

      command = inputs.first
      if inputs.size == 1
        raise logger.warn('Invalid command') unless COMMANDS.include?(command)
        return command
      else
        raise logger.warn('Invalid command') unless COMMANDS_WITH_EMAIL.include?(command)
        email = inputs.last
        # email parsing to be done: sanitizing, validating?
        return [command, email]
      end
    end

    def check_cache
      if store.is_cache_outdated?
        store.set_cache
        logger.info('Retrieving users')
        users = Gateway::Http.get(Figaro.env.root_url + Figaro.env.users_endpoint)
        logger.info('Retrieving purchases')
        purchases = Gateway::Http.get(Figaro.env.root_url + Figaro.env.purchases_endpoint)

        logger.info('Storing users')
        users.each.with_index do |user, i|
          store.set('user', i, 'id', i)
          store.set('user', i, 'email', user.fetch('email'))
        end

        logger.info('Storing purchases')
        purchases.each.with_index do |purchase, i|
          store.set('purchase', i, 'id', i)
          store.set('purchase', i, 'email', purchase.fetch('email'))
          store.set('purchase', i, 'item', purchase.fetch('item'))
          store.set('purchase', i, 'spend', purchase.fetch('spend'))
        end
      end
    end

    attr_accessor :inputs, :store, :logger

    def initialize(inputs)
      self.inputs = inputs
      self.store = Gateway::Persistence.new
      self.logger = Logger.new(STDOUT)
    end
  end
end
