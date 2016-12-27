require 'sequel'
require_relative 'user'

class Tweet
  attr_accessor :db
  def initialize(db = Sequel.sqlite('app.sqlite3'))
    db.create_table? :tweet do
      primary_key :id
      String :text
      Integer :user_id
      String :name
      Time :created_at
    end
    @sqlite_db = db
    @db = db[:tweet]
  end

  def save(request)
    time = Time.now
    user = User.new.find(request[:user_id])
    insert_data = request.update({name: user[:name], created_at: time})
    if user.empty?
      {error: "This user does not exist."}
    else
      result = @db.insert(insert_data)
      res = {id: result}.update{insert_data}
      res
    end
  end

  def find(id)
    tweet = @db.where(id: id)
    if tweet.empty? == false
      tweet.first
    end
  end

  def find_by_user_id(user_id)
    user = User.new.find(user_id)
    if user.empty?
      {error: "This user does not exist."}
    else
      tweets = @db.where(user_id: user_id)
      tweets.all
    end
  end

  def timeline(user_id)
    follows_ids = Follow.new(@sqlite_db).db.where(user_id: user_id).map(:follow_id)
    timeline = follows_ids.map{|follow| self.find_by_user_id(follow)}
    timeline
  end
end
