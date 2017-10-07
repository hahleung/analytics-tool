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
      stats = get_all_purchases(store).reduce({}) do |amount, purchase|
        email = purchase.fetch('email')
        spend = purchase.fetch('spend').to_f

        if amount.key?(email)
          amount[email] += spend
          amount
        else
          amount.merge({email => spend})
        end
      end

      max_amount = stats.values.max

      stats.keep_if { |_, value| value == max_amount }.keys
    end

    private

    def self.get_all_purchases(store)
      store.get_table(PURCHASE_TABLE)
    end
  end
end
