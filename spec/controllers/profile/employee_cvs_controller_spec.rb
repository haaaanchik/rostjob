require 'rails_helper'

RSpec.describe Profile::EmployeeCvsController, type: :controller do
  describe "GET #index" do
    xit "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    xit "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    xit "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #pre_new_full" do
    xit "returns http success" do
      get :pre_new_full
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new_full" do
    xit "returns http success" do
      get :new_full
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    xit "returns http success" do
      get :edit
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create_as_draft" do
    xit "returns http success" do
      get :create_as_draft
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create_as_ready" do
    xit "returns http success" do
      get :create_as_ready
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create_for_send" do
    xit "returns http success" do
      get :create_for_send
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update" do
    xit "returns http success" do
      get :update
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #destroy" do
    xit "returns http success" do
      get :destroy
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #change_status" do
    xit "returns http success" do
      get :change_status
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #to_ready" do
    xit "returns http success" do
      get :to_ready
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #to_disput" do
    xit "returns http success" do
      get :to_disput
      expect(response).to have_http_status(:success)
    end
  end
end
