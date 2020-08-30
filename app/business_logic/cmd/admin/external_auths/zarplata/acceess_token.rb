module Cmd
  module Admin
    module ExternalAuths
      module Zarplata
        class AccessToken
          include Interactor

          delegate :code, to: :context

          def call
            response = ZarplataRu::Auth.access_token(code)
            context.fail!(error: response[:error]) if response[:error].present?

            ExternalAuth.zarplata.update(code: code, values: response)
          end
        end
      end
    end
  end
end
