class List < ActiveRecord::Base
  belongs_to :user
  has_many :purchases, dependent: :destroy

  validates :user, presence: true
  validates :name, presence: true, uniqueness: { :scope => :user }
end