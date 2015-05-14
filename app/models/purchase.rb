class Purchase < ActiveRecord::Base
  belongs_to :list
  belongs_to :product

  validates :list, presence: true
  validates :product, presence: true
end
