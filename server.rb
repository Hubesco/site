# encoding: utf-8
require 'sinatra'
require 'slim'
require 'net/ldap'

set :port, 80
set :bind, '0.0.0.0'

before do
  content_type :html, 'charset' => 'utf-8'
end

# Main page
get '/?' do
  slim :index
end

# Password change page
get '/home/password' do
  slim :change_password
end

# Password change process
post '/home/password' do
  ldap = Net::LDAP.new(
    :host=> 'hubesco.com',
    :port => 389
    :auth => { method: :simple, username: 'n.barbotte', password: 'Cerise6*' }
  )
end

# About page
get '/about' do
  slim :about_us
end

# Ping page
get '/ping/?' do
  'ok'
end

# 404
not_found do
  'Page not found'
end

# Error
error do
  'Erreur - ' + env['sinatra.error'].name
end
