class City < ApplicationRecord
  include Autocompletable

  validates :title, presence: true

  def auto_search_text
    Hash[label: title]
  end
end
