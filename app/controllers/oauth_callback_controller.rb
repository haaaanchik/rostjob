class OauthCallbackController < ApplicationController
  skip_before_action :auth_user

  def superjob
    if params[:code]
      SuperJob::Config.config.update(code: params[:code])
      result = RestClient.get('https://api.superjob.ru/2.0/oauth2/access_token/',
                              params: { client_id: superjob_config['client_id'],
                                        client_secret: superjob_config['client_secret'],
                                        redirect_uri: superjob_config['redirect_uri'],
                                        code: params[:code] })
      SuperJob::Config.config.update(JSON.parse(result.body))
      redirect_to admin_oauth_superjob_path
    end
  end

  def zarplata
    result = Cmd::Admin::ExternalAuths::Zarplata::AccessToken.call(code: params[:code])
    flash[:alert] = result.error if result.failure?

    redirect_to admin_zarplata_authorization_path
  end

  private

  def superjob_config
    Rails.configuration.superjob
  end
end
