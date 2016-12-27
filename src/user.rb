require 'sequel'
require_relative 'session'
require_relative 'follow'
require_relative 'tweet'

class User
  attr_accessor :db
  def initialize(db = Sequel.sqlite('app.sqlite3'))
    db.create_table? :user do
      primary_key :id
      String :name ,unique: true
      String :password
      String :salt
      Time :created_at
    end
    @sqlite_db = db
    @db = db[:user]
  end

  def save(request)
    time = Time.now
    pass_with_salt = Auth.generate_hashed_password_with_salt(request[:password])
    insert_data = request.update(pass_with_salt.merge({created_at: time}))
    id = @db.insert(insert_data)
    Follow.new(@sqlite_db).save(follow_id: id, user_id: id)
    {id: id}
  rescue => _
    {error: "The user already exists."}
  end

  def find(id)
    user = @db.where(id: id)
    if user.empty? == false
      user.first
    end
  end

  def auth(request)
    user_name = request[:name]
    password = request[:password]
    user = @db.where(name: user_name).first

    if user.empty?
      {error: "The user does not exist."}
    else
      salt = user[:salt]
      if user[:password] == Auth.hashed_password(password,salt)
        # token = Session.new(@sqlite_db).save(user[:id])
        {id: user[:id], name: user[:name]}
      else
        {error: "Authentication Failed."}
      end
    end
  end

  def unfollowers(user_id)
    user_ids = @db.map(:id)
    follows_ids = Follow.new(@sqlite_db).db.where(user_id: user_id).map(:follow_id)
    unfollowers = (user_ids - follows_ids).map{|id| self.find(id)}
    unfollowers
  end

end
