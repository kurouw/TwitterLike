require 'sequel'
require_relative 'session'
require_relative 'follow'

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
    user_name = request[:name]
    pass_with_salt = Auth.generate_hashed_password_with_salt(request[:password])
    id = @db.insert(:name => user_name, :password => pass_with_salt[:password], :salt => pass_with_salt[:salt], :created_at => time)
    {id: id}
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

  def unfollowers(id)

  end

end
