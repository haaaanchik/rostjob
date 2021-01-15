# frozen_string_literal: true

module Cmd
  module FreeManager
    class Sample
      include Interactor

      def call
        sample = free_managers.sample
        context.manager = sample ? JSON.parse(sample) : sample
      end

      private

      def free_managers
        @hash = Redis::HashKey.new('free_managers')
        @hash.values
      end
    end
  end
end
