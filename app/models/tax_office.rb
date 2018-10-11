class TaxOffice < ApplicationRecord
  belongs_to :company

  validates :payment_name, :oktmo, :inn, :kpp, :bank_name, :bank_bic, :bank_account, presence: true
end
