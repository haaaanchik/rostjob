module Autocompletable
  extend ActiveSupport::Concern

  module ClassMethods
    def autocomplete_search(term)
      search_by_term(term).map &:auto_search_text
    end

    def search_by_term(params)
      cased = "%#{params.mb_chars.to_s.downcase}%"
      all.select('title')
         .where('(LOWER(title) LIKE ?)', cased)
         .order('title asc')
    end
  end
end
