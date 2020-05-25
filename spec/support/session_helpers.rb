module Features
  module SessionHelpers
    def sign_up
      visit sign_up_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Sign up'
    end

    def sign_in(who, trait = nil)
      user = create(who, trait)
      visit login_path
      fill_in 'E-Mail', with: user.email
      fill_in 'Пароль', with: user.password
      click_button 'Вход'
    end
  end
end