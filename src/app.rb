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

  get '/dataset' do
    users = [{name: "kuro_uw",password: "kuro0220"},{name: "abc",password: "abc1122"},{name: "def", password: "def3344"},{name: "xyz", password: "xyz1234"}]
    follows = [{ follow_id: 2, user_id: 1 },{ follow_id: 4, user_id: 1 },{ follow_id: 1, user_id: 2 },{ follow_id: 3, user_id: 2 },{ follow_id: 4, user_id: 2 },{ follow_id: 2, user_id: 3 }]
    tweets = [{ user_id: 1, text: "foo" },{ user_id: 4, text: "bar" },{ user_id: 1, text: "boo" },{ user_id: 2, text: "i have a pen" },{ user_id: 2, text: "i have an apple"},
      { user_id: 3, text: "applepen"},{ user_id: 3, text: "aaaa" },{ user_id: 4, text: "klfhalkghaierj" }]

    users.each{|user| User.new.save(user)}
    follows.each{|follow| Follow.new.save(follow)}
    tweets.each{|tweet| Tweet.new.save(tweet)}
    result = {msg: "ok"}
    json result
  end

  get '/fire' do
    user = User.new.db
    follow = Follow.new.db
    tweet = Tweet.new.db

    user.select_all.delete
    follow.select_all.delete
    tweet.select_all.delete
    result = {msg: "delete all!"}
    json result
  end

  get '/users' do
    users = User.new.db
    json users.all
  end

  get '/users/:id' do
    json User.new.find(params[:id])
  end

  get '/users/:id/unfollow' do
    json User.new.unfollowers(params[:id])
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
    follow = Follow.new.db
    json follow.all
  end


  get '/follows/:id' do
    json Follow.new.find(params[:id])
  end

  post '/follows' do
    result = Follow.new.save(json_request)
    json result
  end

  get '/tweets' do
    tweets = Tweet.new.db
    json tweets.all
  end

  get '/tweets/:id' do
    json Tweet.new.find(params[:id])
  end

  get '/tweets/user/:user_id' do
    json Tweet.new.find_by_user_id(params[:user_id])
  end

  get '/tweets/timeline/:user_id' do
    json Tweet.new.timeline(params[:user_id])
  end

  post '/tweets' do
    result = Tweet.new.save(json_request)
    json result
  end


end
