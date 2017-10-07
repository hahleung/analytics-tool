require 'bundler/setup'
Bundler.require(:default)

Figaro.application = Figaro::Application.new(path: 'config/application.yml')
Figaro.load

root_path = __dir__
$LOAD_PATH.unshift(root_path)
Dir[root_path + '/lib/**/*.rb'].each { |file| require file }

store = Gateway::Persistence.new

if store.is_cache_outdated?
  store.set_cache
  users = Gateway::Http.get(Figaro.env.root_url + Figaro.env.users_endpoint)
  purchases = Gateway::Http.get(Figaro.env.root_url + Figaro.env.purchases_endpoint)

  users.each.with_index do |user, i|
    store.set('user', i, 'email', user.fetch('email'))
  end

  purchases.each.with_index do |purchase, i|
    store.set('purchase', i, 'email', purchase.fetch('email'))
    store.set('purchase', i, 'item', purchase.fetch('item'))
    store.set('purchase', i, 'spend', purchase.fetch('spend'))
  end
end

binding.pry
