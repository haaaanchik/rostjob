module ControllerMacros
  def login_customer
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      customer = FactoryBot.create(:user, :customer)
      sign_in :user, customer
    end
  end

  def login_contractor
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      contractor = FactoryBot.create(:user, :contractor)
      sign_in :user, contractor
    end
  end
end