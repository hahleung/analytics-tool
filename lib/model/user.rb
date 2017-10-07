module Model
  class User
    private_class_method :new

    def self.get_total_spend(email, store)
      new(email, store).get_total_spend
    end

    def get_total_spend
      Service::Purchase
        .get_by_email(email, store)
        .reduce(0) { |total, purchase| total + purchase.fetch('spend').to_f }
    end

    private

    attr_accessor :email, :store

    def initialize(email, store)    
      self.email = email
      self.store = store
    end
  end
end