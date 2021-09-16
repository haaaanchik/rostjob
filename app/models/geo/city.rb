# frozen_string_literal: true

class Geo::City < ApplicationRecord
  include Autocompletable

  belongs_to :region

  delegate :name, to: :region, allow_nil: true, prefix: :region
  delegate :country_name, to: :region, allow_nil: true

  class << self
    def search_by_term(params)
      cased = "%#{params.mb_chars.to_s.downcase}%"
      select(:name, :region_id).where('(LOWER(name) LIKE ?)', cased).order('name asc')
    end
  end

  def auto_search_text
    Hash[label: "#{name}, #{region_name}, #{country_name}"]
  end
end
