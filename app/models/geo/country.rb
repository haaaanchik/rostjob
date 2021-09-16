# frozen_string_literal: true

class Geo::Country < ApplicationRecord
  has_many :regions, dependent: :destroy
end
