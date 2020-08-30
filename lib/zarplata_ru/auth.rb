module ZarplataRu
  class Auth
    class << self
      include ZarplataRu::Base

      def access_token(code)
        get_access_token(zarplata_config[:oauth_url] + '/access_token',
                         token_body_params(code))
      end

      def refresh_token
        get_access_token(zarplata_config[:oauth_url] + '/access_token',
                         ref_token_body_params)
      end

      private

      def token_body_params(code)
        {
          code: code,
          scope: 'basic',
          client_id: zarplata_config[:client_id],
          grant_type: 'authorization_code',
          client_secret: zarplata_config[:client_secret]
        }
      end

      def ref_token_body_params
        {
          scope: 'basic',
          client_id: zarplata_config[:client_id],
          grant_type: 'refresh_token',
          client_secret: zarplata_config[:client_secret],
          refresh_token: external_auth_zarplata.values['refresh_token']
        }
      end
    end
  end
end