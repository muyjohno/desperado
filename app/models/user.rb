class User < ActiveRecord::Base
  attr_accessor :password
  before_save :set_password

  validates_presence_of :password, on: :create
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_presence_of :password_confirmation, if: :password
  validates_confirmation_of :password, if: :password

  def encrypt_password(password, salt)
    BCrypt::Engine.hash_secret(password, salt)
  end

  def set_password
    return unless password.present?

    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = encrypt_password(password, password_salt)
  end

  def authenticate?(password)
    password_hash == encrypt_password(password, password_salt)
  end

  def self.authenticate(username, password)
    user = find_by_username(username)
    return user if user && user.authenticate?(password)
  end
end
