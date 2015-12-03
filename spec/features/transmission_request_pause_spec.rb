require 'rails_helper'

feature "Transmission pause" , :js do
  let(:user){create(:confirmed_user)}
  let!(:route_provider){create(:route_provider) }

  scenario "while processing" do
    Sidekiq::Testing.fake! do
      compose_transmission_request_until_step 'confirm'
      click_on("Confirmar")
      transmission_request = TransmissionRequest.first
      #page.driver.browser.switch_to.alert.accept

      expect(TransmissionRequestProcessWorker.jobs.size).to eq 1
      TransmissionRequestProcessWorker.jobs.clear

      expect(transmission_request.reload.status).to eq 'scheduled'
      transmission_request.status = 'processing'
      transmission_request.save!
      expect(transmission_request.reload.status).to eq 'processing'


      click_on("Lista de Envios")
      click_on("Pausar")
      page.driver.browser.switch_to.alert.accept
      click_on("Lista de Envios")
      expect(page).to have_content('Pausado')
      expect(transmission_request.reload.status).to eq 'paused'


      expect(MessageRouterWorker.jobs.size).to eq 0
      expect{
        TransmissionRequestProcessWorker.new.perform(transmission_request.id, pause_check=false)
        expect(transmission_request.reload.status).to eq 'finished'
      }.to change{Message.count}.by 2

      # força como pausado pq o comando acima finaliza o processo
      transmission_request.status = 'paused'
      transmission_request.save!
      expect(transmission_request.reload.status).to eq 'paused'

      expect(MessageRouterWorker.jobs.size).to eq 2

      2.times {  MessageRouterWorker.perform_one }
      expect(MessageRouterWorker.jobs.size).to eq 2

      click_on("Lista de Envios")
      expect(page).to have_content('Pausado')
      click_on("Continuar")
      page.driver.browser.switch_to.alert.accept
      click_on("Lista de Envios")
      expect(page).to_not have_content('Pausado')
      expect(page).to have_content('Processando')
      expect(transmission_request.reload.status).to eq 'processing'


      2.times {  MessageRouterWorker.perform_one }
      expect(MessageRouterWorker.jobs.size).to eq 0
    end
  end
end
