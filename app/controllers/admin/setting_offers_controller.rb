# frozen_string_literal: true

class Admin::SettingOffersController < Admin::ApplicationController
  def index
    @setting_offer = SettingOffer.first_or_create
  end

  def update
    @setting_offer = SettingOffer.find(params[:id])

    if @setting_offer.update(setting_offer_params)
      redirect_to admin_setting_offers_path
    else
      render :index
    end
  end


  private

  def setting_offer_params
    params.require(:setting_offer).permit(:customer_offer, :contractor_offer)
  end
end
