require 'rails_helper'

RSpec.describe Profile::Orders::CandidatesController, type: :controller do

  describe "GET #hire" do
    it "returns http success" do
      get :hire
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #fire" do
    it "returns http success" do
      get :fire
      expect(response).to have_http_status(:success)
    end
  end

end
