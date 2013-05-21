# encoding: utf-8
require 'bundler/setup'
require 'sinatra'
require 'slim'
require 'net/ldap'

enable :sessions

set :port, 80
set :bind, '0.0.0.0'
set :show_exceptions, false
set :raise_errors, false

before do
  content_type :html, 'charset' => 'utf-8'
end

# Main page
get '/?' do
  slim :index
end

before '/home*' do
  redirect "/login?redirect=#{request.fullpath}" if session[:username].nil?
end

before '/admin*' do
  redirect '/login' if session[:username].nil?
  if session[:admin].nil?
    #halt 403
  end
end

# Password change page
get '/home/password/?' do
  slim :"home/change_password"
end

# Password change process
post '/home/password' do
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
  params[:redirect] = params[:redirect] || '/'
  if ldap.bind
    session[:username] = params[:username]
    session[:ldap] = ldap
    redirect params[:redirect]
  else
    message = "Could not match user and password."
  end
  redirect "/login?message=#{URI.escape(message)}&username=#{URI.encode(params[:username])}&redirect=#{params[:redirect]}"
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

# Admin
get '/admin/?' do
  slim :"admin/index"
end

get '/admin/users/?' do
  filter = Net::LDAP::Filter.eq("objectClass","person")
  treebase = "dc=hubesco, dc=com"
  result = session[:ldap].search(:base => treebase, :filter => filter)
  slim :"admin/users", :locals=> {:users => result}
end

get '/admin/services/?' do
  slim :"admin/services"
end

# Error handling

not_found do
  slim :"error/hmmm"
end

error 403 do
  slim :"error/forbidden"
end

error do
  slim :"error/generic", :locals => {:error => env['sinatra.error']}
end
