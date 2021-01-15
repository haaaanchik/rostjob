# frozen_string_literal: true

module Api
  class Base < Grape::API
    mount V1::Root
  end
end
