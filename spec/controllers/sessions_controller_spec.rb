require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  include SessionsHelper
  let(:password) { Faker::Internet.password(8) }
  let(:user) { create(:user, password: password) }

  describe '#create' do
    context 'when right credentials are passed' do
      it 'makes user is logged in' do
        post :create, params: { email: user.email, password: password }
        expect(user_signed_in?).to be true
      end
    end

    context 'when wrong credentials are passed' do
      it 'does not makes user is logged in' do
        post :create, params: { email: user.email, password: 'wrong_password' }
        expect(user_signed_in?).to be false
      end
    end
  end

  describe '#destroy' do
    before do
      sign_in(user)
    end

    it 'makes user is logged out' do
      delete :destroy
      expect(user_signed_in?).to be false
    end

    it 'redirects to root path' do
      delete :destroy
      path = URI(response.headers['Location']).path
      expect(path).to eq(root_path)
    end
  end
end
