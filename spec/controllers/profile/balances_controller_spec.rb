require 'rails_helper'

RSpec.describe Profile::BalancesController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #deposit" do
    it "returns http success" do
      get :deposit
      expect(response).to have_http_status(:success)
    end
  end

end
