# frozen_string_literal: true

module Api
  module V1
    module Entities
      class Base < Grape::Entity
        format_with(:iso8601) {|t| t.iso8601 if t }
        format_with(:decimal) {|d| d.to_s('F') if d }
      end
    end
  end
end
