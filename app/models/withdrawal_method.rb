class WithdrawalMethod < ApplicationRecord
  belongs_to :profile

  has_one :company, as: :companyable, dependent: :destroy

  accepts_nested_attributes_for :company

  def withdraw(_amount)
    raise StandardError, 'Method not implemented yet.'
  end
end
