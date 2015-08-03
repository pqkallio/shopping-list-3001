class User < ActiveRecord::Base
  has_secure_password
  has_many :lists, dependent: :destroy

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :username, presence: true, uniqueness: true
  # Ei toiminut Herokussa:
  # validates :email, email: true
  validate :password_validation

  def password_validation
    unless password.match(/[A-Z]/) and password.match(/[[:digit:]]/) and password.length > 7
      errors.add(:password, "The password needs to contain at least one digit and one capital letter, and the minimum password length is eight characters.")
    end
  end
end
