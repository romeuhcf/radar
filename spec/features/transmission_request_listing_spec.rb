require 'rails_helper'

feature 'Transmission request listing', :js do
  let(:user){create(:confirmed_user)}

  scenario 'multipage' do
    create_list(:transmission_request, 10, status: 'cancelled', size: 1)
    create_list(:transmission_request, 10, status: 'processing', size:1)

    sign_in user
    visit(transmission_requests_path)

    expect(page).to have_content("Próximo")
    click_on('Próximo »')
    expect(page).to have_content("Anterior")
  end
end

