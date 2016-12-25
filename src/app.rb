require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/json'
require 'json'
require 'pry'
require_relative 'auth'
require_relative 'user'
require_relative 'follow'
require_relative 'tweet'

class MainApp < Sinatra::Base

  configure do
    register Sinatra::Reloader
    enable :sessions
  end

  def json_request
    JSON.parse(request.body.read, symbolize_names: true)
  end

  get '/users' do
    users = User.new.db
    json users.all
  end

  get '/users/:id' do
    User.new.find(params[:id]).to_json
  end

  get '/users/:id/unfollow' do

  end

  post '/users',provides: :json do
    result = User.new.save(json_request)
    json result
  end

  get '/users/fire' do
    users = User.new.db.delete
  end

  post '/users/auth' do
    result = User.new.auth(json_request)
    json result
  end

  get '/follows' do

  end


  get '/follows/:id' do

  end

  post '/follows' do

  end

  get '/tweets' do
    twees = Tweet.new.db
    twees.all
  end

  get '/tweets/:id' do

  end

  get '/tweets/users/:user_id' do

  end

  get '/tweets/timeline/:user_id' do

  end

  post '/tweets' do
    result = Tweet.new.save(json_request)
    json result
  end


end
