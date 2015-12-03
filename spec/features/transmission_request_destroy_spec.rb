require 'rails_helper'

feature "Transmission request delete" , :js do
  let!(:route_provider){create(:route_provider) }
  let(:user){create(:confirmed_user)}

  scenario 'while just starting composing' do
    compose_transmission_request_until_step
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept

    click_on("Lista de Envios")
    expect(page).to_not have_content('Rascunho')
    expect(page).to_not have_content('Cancelado')
    expect(TransmissionRequest.count).to eq 0
  end

  scenario "while uploaded" do
    compose_transmission_request_until_step 'upload'
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept

    click_on("Lista de Envios")
    expect(page).to_not have_content('Rascunho')
    expect(page).to_not have_content('Cancelado')
    expect(TransmissionRequest.count).to eq 0
  end

  scenario "while defined parse" do
    compose_transmission_request_until_step 'parse'
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept

    click_on("Lista de Envios")
    expect(page).to_not have_content('Rascunho')
    expect(page).to_not have_content('Cancelado')
    expect(TransmissionRequest.count).to eq 0
  end

  scenario "while defined message" do
    compose_transmission_request_until_step 'message'
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept

    click_on("Lista de Envios")
    expect(page).to_not have_content('Rascunho')
    expect(page).to_not have_content('Cancelado')
    expect(TransmissionRequest.count).to eq 0
  end

  scenario "while schedule message" do
    compose_transmission_request_until_step 'schedule'
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept

    click_on("Lista de Envios")
    expect(page).to_not have_content('Rascunho')
    expect(page).to_not have_content('Cancelado')
    expect(TransmissionRequest.count).to eq 0
  end

  scenario "while scheduled" do
    compose_transmission_request_until_step 'confirm'
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept

    click_on("Lista de Envios")
    expect(page).to_not have_content('Rascunho')
    expect(page).to_not have_content('Cancelado')
    expect(TransmissionRequest.count).to eq 0
  end

  scenario "while processing"
  scenario "while paused"
  scenario "while cancelled"

  scenario "while finished" do
    compose_transmission_request_until_step 'confirm'
    Sidekiq::Testing.fake! do
      click_on("Confirmar")
    end

    transmission_request = TransmissionRequest.first
    transmission_request.status = 'processing'
    transmission_request.save!

    click_on("Lista de Envios")
    expect(page).to have_content('Processando')
    click_on("Cancelar")
    page.driver.browser.switch_to.alert.accept
    expect(page).to_not have_content('Rascunho')
    expect(page).to have_content('Cancelado')

    expect(TransmissionRequest.count).to eq 1
  end
end
