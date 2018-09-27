class PriceGroup < ApplicationRecord
  has_many :positions

  validates :title, presence: true
  validates :customer_price, :contractor_price,
            presence: true, numericality: { only_integer: true }
end
