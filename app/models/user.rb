class User < ActiveRecord::Base
  has_secure_password
  belongs_to :group
  has_many :hubs, through: :group
end
