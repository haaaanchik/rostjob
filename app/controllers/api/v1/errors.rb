# frozen_string_literal: true

module Api
  module V1
    class Errors < Grape::Exceptions::Base
      attr :code, :text

      def initialize(opts = {})
        @code    = opts[:code]   || 2000
        @text    = opts[:text]   || ''

        @status  = opts[:status] || 400
        @message = { error: { code: @code, message: @text } }
      end

      def inspect
        message  = @text
        message += " (#{@reason})" if @reason.present?
        %[#<#{self.class.name}: #{message}>]
      end
    end
  end
end
