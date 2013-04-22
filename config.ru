require 'sinatra'
require './server'

set :environment, :production

run Sinatra::Application
