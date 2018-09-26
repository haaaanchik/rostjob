class Company < ApplicationRecord
  belongs_to :profile, optional: true
  has_many :accounts, as: :accountable, dependent: :destroy

  validates :name, :inn, presence: true

  accepts_nested_attributes_for :accounts

  with_options on: :company do |o|
    o.validates :short_name, :address, :mail_address, :phone, :fax,
                :email, :ogrn, :director, :acts_on, presence: true
  end

  scope :own, -> { where own_company: true }
  scope :clients, -> { where own_company: false }

  require 'dadata_api'

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
end
