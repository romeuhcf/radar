require 'rails_helper'

feature 'User logs in' do

  let!(:valid_user) {
    User.create!(email: 'valid@example.com', password: 'password', password_confirmation: 'password').confirm
  }

  scenario 'with valid email and password' do
    sign_in_with 'valid@example.com', 'password'

    expect(page).to have_content('Sessão iniciada com sucesso')
  end

  scenario 'with invalid email' do
    sign_in_with 'invalid_email', 'password'

    expect(page).to have_content('Login')
  end

  scenario 'with blank password' do
    sign_in_with 'valid@example.com', ''

    expect(page).to have_content('Login')
  end

  def sign_in_with(email, password)
    visit new_user_session_path
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_button 'Login'
  end
end
