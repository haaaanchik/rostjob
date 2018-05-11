module Autocompletable
  extend ActiveSupport::Concern

  module ClassMethods
    def autocomplete_search(term)
      search_by_term(term).map &:auto_search_text
    end

    def search_by_term(params)
      cased = "%#{params.mb_chars.to_s.downcase}%"
      all.select('term')
        .where('(LOWER(term) LIKE ?)', cased).order('term asc')
    end
  end
end
