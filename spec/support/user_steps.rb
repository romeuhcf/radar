def sign_in valid_user
  visit new_user_session_path
  fill_in 'user_email', with: valid_user.email
  fill_in 'user_password', with: 'password'
  click_button 'Login'
end


