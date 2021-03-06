class Group < ActiveRecord::Base
  has_and_belongs_to_many :devices
  has_many :users
  validates :name, presence: true
end
