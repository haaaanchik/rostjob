class Company < ApplicationRecord
  # belongs_to :profile, optional: true
  belongs_to :companyable, polymorphic: true
  has_many :accounts, as: :accountable, dependent: :destroy
  has_one :active_account, -> { where(active: true) }, as: :accountable, class_name: 'Account'
  has_many :payment_orders, dependent: :destroy
  has_one :tax_office

  # validates :name, :inn, presence: true

  accepts_nested_attributes_for :accounts
  accepts_nested_attributes_for :tax_office

  with_options on: :company do |o|
    o.validates :short_name, :address, :mail_address, :phone, :fax,
                :email, :ogrn, :director, :acts_on, presence: true
  end

  scope :own, -> { where own_company: true }
  scope :clients, -> { where own_company: false }

  require 'dadata_api'

  def self.search_ifns_dadata(term)
    ifns_by_dadata(term).map { |s| make_result_ifns(s) }
  end

  def self.ifns_by_dadata(params)
    DadataApi.get_ifns(params.mb_chars.to_s.downcase)
  end

  def self.make_result_ifns(raw_fns_data)
    {
      value: raw_fns_data.value,
      code: raw_fns_data.data.code,
      name: raw_fns_data.data.name,
      short_name: raw_fns_data.data.name_short,
      payment_name: raw_fns_data.data.payment_name,
      inn: raw_fns_data.data.inn,
      kpp: raw_fns_data.data.kpp,
      oktmo: raw_fns_data.data.oktmo,
      bank_name: raw_fns_data.data.bank_name,
      bank_bic: raw_fns_data.data.bank_bic,
      bank_account: raw_fns_data.data.bank_account
    }
  end

  def self.search_company_dadata(term)
    find_by_dadata(term).map { |s| make_result_data(s) }
  end

  def self.find_by_dadata(params)
    DadataApi.get_party(params.mb_chars.to_s.downcase)
  end

  def self.make_result_data(raw_company_data)
    short_name = raw_company_data.data.name.short_with_opf
    inn = raw_company_data.data.inn
    address = raw_company_data.data.address.value
    {
      name: raw_company_data.data.name.full_with_opf,
      short_name: short_name,
      address: address,
      ogrn: raw_company_data.data.ogrn,
      inn: inn,
      kpp: raw_company_data.data.kpp,
      director: raw_company_data.data.management.try(:name),
      label: "<span>#{short_name}; #{inn}; #{address}</span>"
    }
  end

  def self.own_active
    own.find_by(active: true)
  end

  def private_person?
    legal_form.include? 'private_person'
  end
end
