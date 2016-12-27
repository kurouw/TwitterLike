require 'sequel'

class Follow
  attr_accessor :db
  def initialize(db = Sequel.sqlite('app.sqlite3'))
    db.create_table? :follow do
      primary_key :id
      Intefer :follow_id
      Integer :user_id
      Time :created_at
    end
    @sqlite_db = db
    @db = db[:follow]
  end

  def save(request)
    time = Time.now
    insert_data = request.update({created_at: time})
    result = @db.insert(insert_data)
    res = {id: result}.update(insert_data)
    res
  rescue => _
    {error: "The user does not exist."}
  end

  def find(id)
    tweet = @db.where(id: id)
    if tweet.empty? == false
      tweet.first
    else
      {error: "The tweet does not exist."}
    end
  end
end
