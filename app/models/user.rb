class User < ApplicationRecord
  has_many :sessions
  has_many :tasks
  validates :username, presence: true, length: { minimum: 3, maximum: 64 }, uniqueness: true
  validates :password, presence: true, length: { minimum: 8, maximum: 64 }

  def authenticate(password)
    if self.password == password
      self
    else
      false
    end
  end
end

