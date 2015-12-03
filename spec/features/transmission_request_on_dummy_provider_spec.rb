require 'rails_helper'

feature "Transmission via dummy" , :js do
  let(:user){create(:confirmed_user)}
  let!(:route_provider){create(:route_provider) }

  scenario "while processing" do
    expect(TransmissionRequest.count).to eq 0
    Sidekiq::Testing.inline! do
      compose_transmission_request_until_step 'confirm'
      click_on("Confirmar")
    end
    expect(TransmissionRequest.count).to eq 1
    sleep 1
    click_on("Lista de Envios")
    transmission_request = TransmissionRequest.first
    expect(transmission_request.reload.status).to eq 'finished'
    expect(transmission_request.messages.size).to eq 2
    expect(page).to have_content("Finalizado")
    click_on("Detalhar")
    expect(page).to have_content("enviado")
    expect(page).to have_content("falho")
  end
end
