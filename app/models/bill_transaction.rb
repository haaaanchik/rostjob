class BillTransaction < ApplicationRecord
  belongs_to :balance
  belongs_to :invoice, required: false

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w[deposit withdrawal] }
  validates :description, presence: true
end
