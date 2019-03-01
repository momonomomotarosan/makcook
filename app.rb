require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
  end
end

before 'menus' do
  if current_user.nil?
    redirect '/'
  end
end

get '/' do
  @lists = List.all
  if current_user.nil?
    @menus = Menu.none
  elsif params[:list].nil? then
    @menus = current_user.menus
  else
    @menus = List.find(params[:list]).menus.where(user_id: current_user.id)
  end
  erb :index
end

get '/signup' do
  erb :sign_up
end

post '/signup' do
  user = User.create(name: params[:name], password: params[:password], password_confirmation: params[:password_confirmation])
  if user.persisted?
    session[:user] = user.id
  end
  redirect '/'
end

get '/signin' do
  erb :sign_in
end

post '/signin' do
  user = User.find_by(name: params[:name])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
  end
  redirect '/'
end

get '/signout' do
  session[:user] = nil
  redirect '/'
end

get '/menus/new' do
  erb :new
end

post '/menus' do
  # date = params[:material].split('-')
  list = List.find(params[:list])
  current_user.menus.create(title: params[:title], material: params[:material], howto: params[:howto], list: list)
  redirect '/'
end

post '/menus/:id/done' do
  menu = Menu.find(params[:id])
  menu.completed = true
  menu.save
  redirect '/'
end

get '/menus/:id/star' do
  menu = Menu.find(params[:id])
  menu.star = !menu.star
  menu.save
  redirect '/'
end

post '/menus/:id/delete' do
  menu = Menu.find(params[:id])
  menu.destroy
  redirect '/'
end

get '/menus/:id/edit' do
  @menu = Menu.find(params[:id])
  erb :edit
end

post '/menus/:id' do
  menu = Menu.find(params[:id])
  list = List.find(params[:list])
  date = params[:material].split('-')
  # menu.title = CGI.escapeHTML(params[:title])
  # menu.material = Date.parse(params[:material])
  # menu.howto = CGI.escapeHTML(params[:howto])
  # menu.list_id = list.id
  # menu.save
  # redirect '/'
  # redirect "/menus/#{menu.id}/edit"

  menu.title = CGI.escapeHTML(params[:title])
  menu.material = CGI.escapeHTML(params[:material])
  menu.howto = CGI.escapeHTML(params[:howto])
  menu.list = CGI.escapeHTML(params[:list_id])
  redirect '/'
end

get '/menus/over' do
  @lists = List.all
  @menus = current_user.menus.where('material < ?', Date.today).where(completed: [nil, false])
  erb :index
end

get '/menus/done' do
  @lists = List.all
  @menus = current_user.menus.where('material < ?', Date.today).where(completed: [true])
  erb :index
end

# post '/signin' do
#   "Hello World"
# end
# これじゃダメ