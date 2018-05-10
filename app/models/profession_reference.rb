class ProfessionReference < ApplicationRecord
  include Autocompletable

  def auto_search_text
    Hash[label: term]
  end
end
