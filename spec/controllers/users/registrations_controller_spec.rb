require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:email) { Faker::Internet.unique.email }

  let(:create_params) do
    {
      user: {
        email: email,
        password: Faker::Internet.password,
        profile: {
          phone: Faker::PhoneNumber.phone_number,
          email: email,
          company_name: Faker::Company.name,
          contact_person: Faker::Name.name,
          profile_type: %w[employer agency employee recruiter].sample
        }
      }
    }
  end

  let(:profile_keys) { create_params[:user][:profile].keys }

  subject(:perform) { post :create, params: create_params }

  describe '#create' do
    it 'creates new fully filled profile' do
      expect { perform }.to change { Profile.count }.from(0).to(1)
      result = Profile.first.slice(profile_keys).symbolize_keys
      expect(result).to eq(create_params[:user][:profile])
    end

    it 'creates new user associated with this profile' do
      expect { perform }.to change { User.count }.from(0).to(1)
      profile = User.first.profile
      result = profile.slice(profile_keys).symbolize_keys
      expect(result).to eq(create_params[:user][:profile])
    end

    context 'when data invalid' do

      let(:invalid_create_params) do
        create_params[:user][:profile].delete(:phone)
        create_params
      end

      subject(:perform) { post :create, params: invalid_create_params }


      it "don't creates profile" do
        expect { perform }.to_not change { Profile.count }
      end

      it "don't creates user" do
        expect { perform }.to_not change { User.count }
      end
    end
  end
end
