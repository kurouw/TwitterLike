require 'openssl'
require 'securerandom'

# Authenticate utility module
module Auth
  # ハッシュ化されたパスワードを生成する
  def self.generate_hashed_password(password)
    OpenSSL::Digest::SHA256.hexdigest(password)
  end

  # ストレッチする
  def self.stretch(password)
    # ここにストレッチングの処理を追記
    1000.times{password = Auth.generate_hashed_password(password)}
    password
  end

  # パスワードにソルトをかける
  def self.splinkle_salt(password, salt_length = 16)
    salt = SecureRandom.base64(salt_length)
    # ここに、key = :passwordでpassword_with_saltの値を持ち、key = :saltでsaltの値を持つハッシュ(map)を返す処理を記述
    password_with_salt = password + salt
    {:password => password_with_salt,:salt => salt}
  end

  # ソルト付きパスワードを生成する
  def self.generate_hashed_password_with_salt(password, salt_length = 16)
    pass_with_salt = Auth.splinkle_salt(password, salt_length)
    hashed_pass = Auth.stretch(pass_with_salt[:password])
    pass_with_salt.update(password: hashed_pass)
  end

  # ソルトとパスワードを渡して、ハッシュを得る
  def self.hashed_password(password, salt)
    Auth.stretch(password + salt)
  end
end
