# frozen_string_literal: true

class Geo::Region < ApplicationRecord
  has_many :cities, dependent: :delete_all
  belongs_to :country
  delegate :name, to: :country, allow_nil: true, prefix: true
end
