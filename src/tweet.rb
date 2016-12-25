require 'sequel'
require_relative 'user'

class Tweet
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
    user_id = request[:user_id]
    text = request[:text]

    if user_id.empty? || text.empty?
      {error: "Invalid request."}
    else
      user = User.new.find(user_id)
      if user.empty?
        {error: "This user does not exist."}
      else
        result = @db.insert(text: request[:text], user_id: user_id, name: user[:name], created_at: time)
        result
      end
    end
  end

  def find(id)
    tweet = @db.where(id: id)
    if tweet.empty? == false
      tweet.first
    end
  end

  def find_by_user_id(user_id)
    user = User.new.(@sqlite_db).find(user_id)
    if user.empty?
      {error: "This user does not exist."}
    else
      tweets = @db.where(user_id: user_id)
      tweets
    end
  end

  def timeline(user_id)
  end
end
