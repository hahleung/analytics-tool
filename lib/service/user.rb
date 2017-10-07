module Service
  class User
    PURCHASE_TABLE = 'purchase'.freeze

    def self.most_loyal(store)
      occurences = Hash.new(0)

      get_all_purchases(store).each do |purchase|
        occurences[purchase.fetch('email')] += 1
      end

      max_purchases = occurences.values.max

      occurences.keep_if { |_, value| value == max_purchases }.keys
    end

    def self.highest_value(store)
      amounts = Hash.new(0)

      get_all_purchases(store).each do |purchase|
        amounts[purchase.fetch('email')] += purchase.fetch('spend').to_f
      end

      max_amount = amounts.values.max

      amounts.keep_if { |_, value| value == max_amount }.keys
    end

    private

    def self.get_all_purchases(store)
      store.get_table(PURCHASE_TABLE)
    end
  end
end
