require 'sequel'

class Follow
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
end
