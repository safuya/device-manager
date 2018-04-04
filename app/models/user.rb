class User < ActiveRecord::Base
  has_secure_password
  belongs_to :group
  has_many :hubs, through: :group
  validates :username, :name, :email, presence: true
  validates :password, length: { minimum: 8 }
  validate :password_complexity

  def password_complexity
    complexity = 0
    complexity += 1 if password =~ /[a-z]/
    complexity += 1 if password =~ /[A-Z]/
    complexity += 1 if password =~ /\d/
    complexity += 1 if password =~ /[$@&!%*^#]/

    errors.add(
      :password,
      'is not complex (3 of 4 digit, symbol, upper, lower)'
    ) if complexity < 3
  end
end
