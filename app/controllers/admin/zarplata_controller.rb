class Admin::ZarplataController < Admin::ApplicationController
  def authorization
    @zarplata = ExternalAuth.zarplata.decorate
  end

  def refresh_token
    result = Cmd::Admin::ExternalAuths::Zarplata::RefreshToken.call

    if result.failure?
      flash[:alert] = result.error
      ExternalAuth.zarplata.update(values: nil)
    end

    redirect_to admin_zarplata_path
  end

  def order
    @order = Order.find(params[:id]).decorate
  end

  def publish
    @result = Cmd::Admin::ExternalAuths::Zarplata::Publish.call(params: params[:zarplata])
  end
end
