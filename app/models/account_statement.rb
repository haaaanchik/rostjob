class AccountStatement < ApplicationRecord
  include AASM
  belongs_to :account

  validates :number, :date, :amount, :sender, :src_account, :data, presence: true

  aasm column: :state, skip_validation_on_save: true, no_direct_assignment: false do
    state :uploaded, initial: true
    state :handled
    state :unidentified

    event :to_handled do
      transitions from: :uploaded, to: :handled
    end

    event :to_unidentified do
      transitions from: :created, to: :unidentified
    end
  end

  def income?
    src_account != account.account_number
  end

  def outcome?
    src_account == account.account_number
  end
end
