require 'rails_helper'

feature 'Send inline sms' do

  scenario 'valid phone list and valid message' do
    expect(Message.count).to eq 0
    expect(TransmissionRequest.count).to eq 0
    valid_user_sign_in
    visit(new_inline_sms_request_path)
    fill_in 'Telefones', with: "11960758475, 11960758475\n , 11966665555 11987653333"
    fill_in 'Mensagem', with: 'Hello world'
    click_button 'Enviar'

    expect(page).to have_content('Mensagens enviadas com sucesso: 3')
    expect(Message.count).to eq 3
    expect(TransmissionRequest.count).to eq 1
  end

  scenario 'invalid phone list and valid message' do
    expect(Message.count).to eq 0
    valid_user_sign_in
    visit(new_inline_sms_request_path)
    fill_in 'Telefones', with: "5 4 3 2 1"
    fill_in 'Mensagem', with: 'Hello world'
    click_button 'Enviar'

    expect(page).to have_content('invalid')
    expect(Message.count).to eq 0
    expect(TransmissionRequest.count).to eq 0
  end

  scenario 'valid phone list and invalid message' do
    expect(Message.count).to eq 0
    valid_user_sign_in
    visit(new_inline_sms_request_path)
    fill_in 'Telefones', with: "11960758475, 11960758475\n , 11966665555 11987653333"
    fill_in 'Mensagem', with: 'H'
    click_button 'Enviar'

    expect(page).to have_content('muito curto')
    expect(Message.count).to eq 0
    expect(TransmissionRequest.count).to eq 0
  end

  def valid_user_sign_in
    valid_user = User.create!(email: 'valid@example.com', password: 'password', password_confirmation: 'password', confirmed_at: Time.now)
    visit new_user_session_path
    fill_in 'user_email', with: valid_user.email
    fill_in 'user_password', with: 'password'
    click_button 'Login'
  end

end
