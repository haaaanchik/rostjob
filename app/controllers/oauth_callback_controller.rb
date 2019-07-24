class OauthCallbackController < ApplicationController
  skip_before_action :auth_user
  skip_before_action :create_profile

  def superjob
    if params[:code]
      SuperJob.config.update(code: params[:code])
      result = RestClient.get('https://api.superjob.ru/2.0/oauth2/access_token/',
                              params: { client_id: superjob_config['client_id'],
                                        client_secret: superjob_config['client_secret'],
                                        redirect_uri: superjob_config['redirect_uri'],
                                        code: params[:code] })
      SuperJob.config.update(JSON.parse(result.body))
      redirect_to admin_oauth_superjob_path
    end
  end

  private

  def superjob_config
    Rails.configuration.superjob
  end
end
