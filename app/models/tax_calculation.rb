class TaxCalculation < ApplicationRecord
  belongs_to :profile

  before_validation :calculate_tax

  validates :tax_base, :tax_amount, presence: true, numericality: { only_integer: true }

  def calculate_tax
    self.tax_amount = (tax_base * 0.13).round
  end
end
