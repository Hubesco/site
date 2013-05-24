# encoding: utf-8
require 'bundler/setup'
require 'sinatra'
require 'slim'
require 'net/ldap'
require 'i18n'
require 'i18n/backend/fallbacks'

=begin
use Rack::Session::Cookie, :key => 'rack.session',
                           :domain => 'localhost',
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => 'hubesco'
=end

enable :sessions

set :port, 80
set :bind, '0.0.0.0'

configure do
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path += Dir[File.join(settings.root, 'locales', '*/*.yml')]
  I18n.backend.load_translations
end

helpers do
  def get_locale
    # Pulls the browser's language
    # @env["HTTP_ACCEPT_LANGUAGE"][0,2]
  end

  def t(*args)
    # Just a simple alias
    I18n.t(*args)
  end
end

before do
  content_type :html, 'charset' => 'utf-8'
end

before '/:locale?/*' do
  puts "------------------- SPLATS: #{params[:splat ]}"
  I18n.locale = params[:locale] if params[:locale]
  request.path_info = '/' + params[:splat][0]
end

# Main page
get '/?' do
  slim :index
end

# Password change page
get '/home/password/?' do
  redirect '/login' if session[:username].nil?
  slim :change_password
end

# Password change process
post '/home/password' do
  redirect '/login' if session[:username].nil?
  ldap = Net::LDAP.new
  ldap.host = "hubesco.com"
  ldap.port = 389
  ldap.auth "uid=#{session[:username]},ou=People,dc=hubesco,dc=com", params[:current_password]
  if ldap.bind
    begin
      newPassword = Net::LDAP::Password.generate :ssha, params[:new_password]
      ldap.replace_attribute "uid=#{session[:username]},ou=People,dc=hubesco,dc=com", "userPassword", newPassword
      redirect '/'
    rescue
      message = "Server error. Could not change password."
    end
  else
    message = "Could not match user and password."
  end
  redirect "/home/password?message=#{URI.escape(message)}"
end

#login
get '/login/?' do
  slim :login
end

post '/login' do
  ldap = Net::LDAP.new
  ldap.host = "hubesco.com"
  ldap.port = 389
  ldap.auth "uid=#{params[:username]},ou=People,dc=hubesco,dc=com", params[:password]
  if ldap.bind
    session[:username] = params[:username]
    redirect "/"
  else
    message = "Could not match user and password."
  end
  redirect "/login?message=#{URI.escape(message)}&username=#{URI.encode(params[:username])}"
end

get '/logout/?' do
  session.clear
  redirect '/'
end

# About page
get '/about/?' do
  slim :about_us
end

# About page
get '/pricing/?' do
  slim :pricing
end

# Ping page
get '/ping/?' do
  'ok'
end

# Redirects
get '/mail/?' do
  redirect "https://mail.hubesco.com"
end

get '/cloud/?' do
  redirect "https://cloud.hubesco.com"
end

# 404
not_found do
  'Page not found'
end

# Error
error do
  'Erreur - ' + env['sinatra.error'].name
end

# Tests
get '/test/?' do
  slim :test
end
