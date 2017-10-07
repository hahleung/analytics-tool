require 'bundler/setup'
Bundler.require(:default)

Figaro.application = Figaro::Application.new(path: 'config/application.yml')
Figaro.load

root_path = __dir__
$LOAD_PATH.unshift(root_path)
Dir[root_path + '/lib/**/*.rb'].each { |file| require file }

Orchestrator::Maestro.call(ARGV)
