class Account < ApplicationRecord
  belongs_to :accountable, polymorphic: true
  has_many :account_statements

  validates :bank, :bank_address, :bic, :account_number, :corr_account, presence: true, unless: -> { accountable.legal_form == 'partner' }

  def initialize(attrs = nil)
    defaults = {
      active: true
    }
    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end

  def self.search_bank_dadata(term)
    find_by_dadata(term).map { |s| make_result_data(s) }
  end

  def self.find_by_dadata(params)
    DadataApi.get_bank(params.mb_chars.to_s.downcase)
  end

  def self.make_result_data(raw_bank_data)
    bank = raw_bank_data.data.name.payment
    bic = raw_bank_data.data.bic
    {
      bank: bank,
      bank_address: raw_bank_data.data.address.value,
      corr_account: raw_bank_data.data.correspondent_account,
      bic: bic,
      label: "#{bank}; #{bic}"
    }
  end
end
