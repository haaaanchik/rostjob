class BillTransaction < ApplicationRecord
  belongs_to :balance

  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0}
  validates :transaction_type, presence: true, inclusion: { in: %w[deposit withdrawal] }
  validates :description, presence: true
end
