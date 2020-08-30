module Cmd
  module Admin
    module ExternalAuths
      module Zarplata
        class Publish
          include Interactor

          delegate :params, to: :context

          def call
            result = ZarplataRu::Vacancy.publish(params)
            context.fail!(error: result[:error]) if result[:error].present?
          end
        end
      end
    end
  end
end
