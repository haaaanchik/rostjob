module FeatureMacros
  def login_customer
    let(:user) {create(:user, :customer) } 
    visit login_path
    fill_in 'E-Mail', with: user.email
    fill_in 'Пароль', with: user.password
    click_button 'Вход'
  end

  def login_contractor
    user = create(:user, :contractor)
    visit login_path
    fill_in 'E-Mail', with: user.email
    fill_in 'Пароль', with: user.password
    click_button 'Вход'
  end
end