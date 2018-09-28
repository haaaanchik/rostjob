class Position < ApplicationRecord
  include Autocompletable

  belongs_to :price_group

  validates :title, presence: true

  def self.search_by_term(params)
    cased = "%#{params.mb_chars.to_s.downcase}%"
    all.includes(:price_group)
       .where('(LOWER(title) LIKE ?)', cased)
       .order('title asc')
  end

  def auto_search_text
    Hash[id: id, label: title, duties: duties, price: price_group.customer_price]
  end
end
