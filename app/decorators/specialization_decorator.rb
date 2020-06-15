# frozen_string_literal: true

class SpecializationDecorator < ApplicationDecorator
  def display_position_titles
    return if positions.blank?

    positions.map(&:title).join('<br>')
  end
end
