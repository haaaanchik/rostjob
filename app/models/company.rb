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

  validates :legal_form, presence: true

  with_options if: :company?, on: :update do |o|
    o.validates :short_name, :address, :mail_address, :phone,
                :email, :ogrn, :director, :acts_on, presence: true

    o.validates :inn, numericality: { only_integer: true }, if: -> { companyable.customer? }
    o.validate :check_inn_length, if: -> { companyable.customer? }
  end

  with_options if: :ip?, on: :update do |comp|
    comp.validates :ogrn, :email, :phone, :mail_address,
                   :address, :short_name, :name, presence: true

    comp.validates :inn, length: { is: 12 }, numericality: { only_integer: true }
  end

  with_options if: :private_person?, on: :update do |pers|
    pers.validates :name, presence: true

    pers.validates :inn, length: { is: 12 }, numericality: { only_integer: true }
  end

  with_options if: :contractor_phone?, on: :update do |comp|
    comp.validates :phone, presence: true
  end


  scope :own, -> { where own_company: true }
  scope :clients, -> { where own_company: false }

  require 'dadata_api'
  class << self

    def search_ifns_dadata(term)
      ifns_by_dadata(term).map { |s| make_result_ifns(s) }
    end

    def ifns_by_dadata(params)
      DadataApi.get_ifns(params.mb_chars.to_s.downcase)
    end

    def make_result_ifns(raw_fns_data)
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

    def search_company_dadata(term)
      find_by_dadata(term).map { |s| make_result_data(s) }
    end

    def find_by_dadata(params)
      DadataApi.get_party(params.mb_chars.to_s.downcase)
    end

    def make_result_data(raw_company_data)
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

    def own_active
      own.find_by(active: true)
    end
  end

  def private_person?
    legal_form.include? 'private_person'
  end

  def ip?
    legal_form == 'ip'
  end

  def company?
    legal_form == 'company'
  end

  def contractor_phone?
    legal_form == 'contractor'
  end

  private

  def check_inn_length
    return if inn.size == 10 || inn.size == 12

    errors.add(:inn, 'длина должна быть равна 10 или 12')
  end
end
