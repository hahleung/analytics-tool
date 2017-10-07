ENV['RACK_ENV'] = 'test'

require 'bundler/setup'
Bundler.require(:default)

root_path = __dir__
$LOAD_PATH.unshift(root_path)
Dir[root_path + '/lib/**/*.rb'].each { |file| require file }
