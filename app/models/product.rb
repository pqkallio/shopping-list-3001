class Product < ActiveRecord::Base
  has_many :purchases, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end