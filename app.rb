require 'bundler/setup'
Bundler.require(:default)

Figaro.application = Figaro::Application.new(path: "config/application.yml")
Figaro.load

root_path = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(root_path)
Dir[root_path + "/lib/**/*.rb"].each { |file| require file }

a = Gateway::Http.get(Figaro.env.root_url + Figaro.env.purchases_endpoint)
binding.pry