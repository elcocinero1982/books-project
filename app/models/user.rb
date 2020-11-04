class User < ActiveRecord::Base
    has_secure_password
    validates :email, presence: true, uniqueness: true
  has_many :books, foreign_key: "author_id"
end
