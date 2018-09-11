class Company < ApplicationRecord
  has_many :accounts, dependent: :destroy

  validates :name, :short_name, :address, :mail_address, :phone, :fax,
            :email, :inn, :kpp, :ogrn, :director, :acts_on, presence: true

  accepts_nested_attributes_for :accounts

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
