class PositionReference < ApplicationRecord
  include Autocompletable

  def self.search_by_term(params)
    cased = "%#{params.mb_chars.to_s.downcase}%"
    all.select('term, duties')
      .where('(LOWER(term) LIKE ?)', cased).order('term asc')
  end

  def auto_search_text
    Hash[label: term, duties: duties]
  end
end
