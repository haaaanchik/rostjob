class Position < ApplicationRecord
  include Autocompletable

  belongs_to :price_group, optional: true

  validates :title, presence: true

  def self.search_by_term(params)
    cased = "%#{params.mb_chars.to_s.downcase}%"
    all.select('title, duties')
       .where('(LOWER(title) LIKE ?)', cased)
       .order('title asc')
  end

  def auto_search_text
    Hash[label: title, duties: duties]
  end
end
