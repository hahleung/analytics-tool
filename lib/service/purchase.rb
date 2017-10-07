module Service
  class Purchase
    PURCHASE_TABLE = 'purchase'.freeze

    def self.get_by_email(email, store)
      get_all(store).select do |purchase|
        purchase.fetch('email') == email
      end
    end

    private 

    def self.get_all(store)
      store.get_table(PURCHASE_TABLE)
    end
  end
end
