# frozen_string_literal: true

class SearchPositionQuery < ApplicationQuery
  attr_accessor :term

  def call
    Position
      .ransack(term)
      .result
      .select(:id, :title)
  end
end
