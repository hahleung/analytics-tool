module Service
  class Purchase
    PURCHASE_TABLE = 'purchase'.freeze

    def self.get_by_email(email, store)
      get_all(store).select do |purchase|
        purchase.fetch('email') == email
      end
    end

    def self.most_sold(store)
      occurences = Hash.new(0)

      get_all(store).each do |purchase|
        occurences[purchase.fetch('item')] += 1
      end

      max_frequency = occurences.values.max

      occurences.keep_if { |_, value| value == max_frequency }.keys
    end

    private 

    def self.get_all(store)
      store.get_table(PURCHASE_TABLE)
    end
  end
end
