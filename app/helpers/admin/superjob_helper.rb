module Admin::SuperjobHelper
  def superjob_authorize_url
    superjob_config = Rails.configuration.superjob
    query_params = {
      client_id: superjob_config['client_id'],
      redirect_uri: superjob_config['redirect_uri']
    }
    "#{superjob_config['base_url']}/authorize?#{query_params.to_query}"
  end
end
