# frozen_string_literal: true

class ApiKey < ApplicationRecord
  validates :name, :token, presence: true
end