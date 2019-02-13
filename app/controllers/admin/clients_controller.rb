class Admin::ClientsController < Admin::ApplicationController
  def index
    @clients_search_form = ClientsSearchForm.new(clients_search_form_params)
    @clients = @clients_search_form.submit
    @type = @clients_search_form.client_type
  end

  private

  def clients_search_form_params
    params.permit(:query, :type)
  end
end
