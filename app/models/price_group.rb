class PriceGroup < ApplicationRecord
  has_many :positions

  validates :title, presence: true
  validates :price, presence: true, numericality: { only_integer: true }
end
