class Device < ActiveRecord::Base
  has_and_belongs_to_many :groups
  has_many :users, through: :groups
  validates :serial_number, :model, presence: true
  validates :serial_number, uniqueness: true
  validates :serial_number, length: { minimum: 1 }
end
