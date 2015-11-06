require 'rails_helper'

feature 'User signs up'do
  scenario 'with valid email and password' do
    expect do
#      expect do
        signs_up_with 'valid@example.com', 'password'
#      end.to change { Devise.mailer.deliveries.size }.by(1)
      expect(current_path).to_not eq dashboard_index_path
    end.to change { User.count }.by(1)
  end

  def signs_up_with(email, password)
    visit new_user_registration_path
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    click_button 'Inscrever-se'
  end
end
