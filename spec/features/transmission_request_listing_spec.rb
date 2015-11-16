require 'rails_helper'

feature 'Transmission request listing', :js do
  let(:user){create(:confirmed_user)}

  scenario 'multipage' do
    create_list(:transmission_request, 10, status: 'cancelled', size: 0, owner: user)
    create_list(:transmission_request, 10, status: 'processing', size: 0, owner: user)

    sign_in user
    visit(transmission_requests_path)

    expect(page).to have_content("Próximo")
    click_on('Próximo »')
    expect(page).to have_content("Anterior")
  end
end

