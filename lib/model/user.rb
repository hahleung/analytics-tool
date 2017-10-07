module Model
  class User
    private_class_method :new

    def self.get_total_spend(email, store)
      new(email, store).get_total_spend
    end

    def self.get_average_spend(email, store)
      new(email, store).get_average_spend
    end

    def get_total_spend
      purchases.reduce(0) do |total, purchase|
        total + purchase.fetch('spend').to_f
      end.round(2)
    end

    def get_average_spend
      return 0 if purchases.size.zero?
      (get_total_spend / purchases.size).round(2)
    end

    private

    attr_accessor :email, :store, :purchases

    def initialize(email, store)    
      self.email = email
      self.store = store
      self.purchases = Service::Purchase.get_by_email(email, store)
    end
  end
end