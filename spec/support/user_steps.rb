def valid_user_sign_in
  valid_user = User.create!(email: 'valid@example.com', password: 'password', password_confirmation: 'password', confirmed_at: Time.now)
  visit new_user_session_path
  fill_in 'user_email', with: valid_user.email
  fill_in 'user_password', with: 'password'
  click_button 'Login'
end


