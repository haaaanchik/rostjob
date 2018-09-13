require 'rails_helper'

RSpec.describe Admin::InvoicesController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #pay" do
    it "returns http success" do
      get :pay
      expect(response).to have_http_status(:success)
    end
  end

end
