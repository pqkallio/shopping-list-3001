class UserLogIn < ActiveRecord::Base
  belongs_to :user

  scope :logged_in, -> { where logout_time:nil }
end