class AccountStatement < ApplicationRecord
  belongs_to :account

  validates :number, :date, :amount, :sender, :src_account, :data, presence: true
end
