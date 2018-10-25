require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  include SessionsHelper

  let(:password) { Faker::Internet.password(8) }
  let(:user) { create(:user, password: password) }

  describe 'GET #index' do
    context 'when user is logged in' do
      context 'when user has no profile' do
        it 'redirects to new_profile_path' do
          sign_in(user)
          get :index
          path = URI(response.headers['Location']).path
          expect(path).to eq(new_profile_path)
        end
      end
    end
  end
end
