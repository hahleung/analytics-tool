require 'bundler/setup'
Bundler.require(:default)

Figaro.application = Figaro::Application.new(path: 'config/application.yml')
Figaro.load

root_path = __dir__
$LOAD_PATH.unshift(root_path)
Dir[root_path + '/lib/**/*.rb'].each { |file| require file }

store = Gateway::Persistence.new
logger = Logger.new(STDOUT)

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

t = Service::Purchase.get_by_email('smith_briana@ziemannjacobson.com', store)
s = Model::User.get_total_spend('smith_briana@ziemannjacobson.com', store)
q = Model::User.get_average_spend('smith_briana@ziemannjacobson.com', store)
y = Service::User.most_loyal(store)

binding.pry
