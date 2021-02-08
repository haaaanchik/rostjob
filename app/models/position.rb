class Position < ApplicationRecord
  include Autocompletable

  belongs_to :price_group
  has_many :orders, dependent: :restrict_with_error
  has_and_belongs_to_many :specializations

  validates :title, :landing_title, :warranty_period, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :warranty_period, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  ransack_alias :title_fields, :title

  def self.search_by_term(params)
    cased = "%#{params.mb_chars.to_s.downcase}%"
    all.includes(:price_group)
       .where('(LOWER(title) LIKE ?)', cased)
       .order('title asc')
       .limit(50)
  end

  def auto_search_text
    Hash[id: id, label: title, duties: duties,
         price: price_group.customer_price,
         contractor_price: price_group.contractor_price]
  end

  def search
    nil
  end
end
