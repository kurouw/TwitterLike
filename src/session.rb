class Session
  def initialize(db = Sequel.sqlite('app.sqlite3'))
    db.create_table? :session do
      primary_key :id
      String :user_id
      String :token
    end
    @sqlite_db = db
    @db = db[:session]
  end

  def save(id)
    {token: "aaa"}
  end

end
