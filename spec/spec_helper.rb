require File.join(File.dirname(__FILE__), '../server.rb')

require 'sinatra'
require 'rspec'
require 'rack/test'
require 'capybara/rspec'

# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  Sinatra::Application
end

$vars = YAML.load_file("spec/config.yml")

Capybara.app = app

RSpec.configure do |config|
  config.include Rack::Test::Methods
end