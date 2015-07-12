require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter('.gems')
end

ENV['RACK_ENV'] ||= 'test'

require 'tilt/jbuilder'
require 'sinatra/jbuilder'
require 'rack/test'
require 'sinatra/base'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Sinatra::Base.set :environment,  :test

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include SinatraIntegrationTestMethods
end
