require 'rails_helper'

def compose_transmission_request_until_step(step =nil)
  sign_in user
  click_on('Relatórios')
  click_on('Enviar lote')
  return if step.nil?

  attach_file('Arquivo', File.absolute_path(fixture_file('simple_sms.csv')))
  click_on("Próximo passo")
  return if step == 'upload'

  uncheck("Títulos das colunas na primeira linha")
  click_on("Próximo passo")
  return if step == 'parse'

  check("Usar mensagem de uma coluna?")
  select("B", from: "Coluna das mensagens")
  select("A", from: "Coluna dos telefones")
  click_on("Próximo passo")
  return if step == 'message'

  ini = "2020/10/10 12:13"
  fin = "2020/10/11 12:13"
  page.execute_script("$('#transmission_request_options_schedule_start_time').val('#{ini}')")
  page.execute_script("$('#transmission_request_options_schedule_finish_time').val('#{fin}')")
  select("Horário Comercial (08:00 às 19:00)", from: 'Horários válidos')
  click_on("Próximo passo")
  return if step == 'schedule'

  # Confirmar step
  expect(page).to have_content('"Mensagem de teste 1"')
  expect(page).to have_content('3 mensagens')
  return if step == 'confirm'
end

feature "Transmission request delete" , :js do
  let(:user){create(:confirmed_user)}

  scenario 'while just starting composing' do
    compose_transmission_request_until_step
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept
  end

  scenario "while uploaded" do
    compose_transmission_request_until_step 'upload'
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept
  end

  scenario "while defined parse" do
    compose_transmission_request_until_step 'parse'
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept
  end

  scenario "while defined message" do
    compose_transmission_request_until_step 'message'
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept
  end

  scenario "while schedule message" do
    compose_transmission_request_until_step 'schedule'
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept
  end

  scenario "while scheduled" do
    compose_transmission_request_until_step 'confirm'
    click_on("Desistir")
    page.driver.browser.switch_to.alert.accept

  end
  scenario "while processing"
  scenario "while paused"
  scenario "while cancelled"
end
