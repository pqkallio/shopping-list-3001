class User < ActiveRecord::Base
  has_secure_password
  has_many :lists, dependent: :destroy
  has_many :user_log_in, dependent: :destroy
  has_many :owner_friendship_requests, :class_name => "FriendshipRequest", :foreign_key => "owner_id", dependent: :destroy
  has_many :target_friendship_requests, :class_name => "FriendshipRequest", :foreign_key => "target_id", dependent: :destroy

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

  def get_available
    if UserLogIn.logged_in.find_by(user_id: id)
      true
    else
      false
    end
  end

  def get_last_signin
    logins = UserLogIn.where(user_id: id).order(created_at: :desc)

    unless logins.empty?
      logins.first.created_at
    else
      Time.new(1900)
    end
  end

  def get_last_seen
    logins = UserLogIn.where(user_id: id).order(created_at: :desc)

    unless logins.empty?
      logins.first.logout_time
    else
      Time.new(1900)
    end
  end
end
