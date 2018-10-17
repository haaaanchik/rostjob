require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    include SessionsHelper

    subject(:perform) { post :create, params: user }

    let(:password) { Faker::Internet.password(8) }
    let(:user) do
      { user: { full_name: Faker::Name.name, email: Faker::Internet.email,
                password: password, password_confirmation: password } }
    end

    it 'creates new user account' do
      expect { perform }.to change(User, :count).by(1)
    end

    it 'signs in new user' do
      perform
      expect(user_signed_in?).to eq(true)
    end

    it 'redirects to root_path' do
      perform
      path = URI(response.headers['Location']).path
      expect(path).to eq(root_path)
    end
  end
end
