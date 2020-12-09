# frozen_string_literal: true

module Cmd
  module Jobs
    module Order
      class Publication
        include Interactor

        delegate :invoice, to: :context

        def call
          context.fall! unless invoice

          OrderPublicationJob.perform_later(invoice.id)
        end
      end
    end
  end
end
