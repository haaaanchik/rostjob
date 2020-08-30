module Cmd
  module Admin
    module ExternalAuths
      module Zarplata
        class RefreshToken
          include Interactor

          def call
            response = ZarplataRu::Auth.refresh_token
            context.fail!(error: response[:error]) if response[:error].present?

            ExternalAuth.zarplata.update(values: response)
          end
        end
      end
    end
  end
end
