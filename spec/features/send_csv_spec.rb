require 'rails_helper'


def start_creating_transmission_request_with_csv(basename)
  sign_in user
  click_on('Relatórios')
  click_on('Enviar lote')

  attach_file('Arquivo', File.absolute_path(fixture_file(basename)))
  click_on("Próximo passo");

  # Parse step
  select('csv', from: "Tipo de arquivo")
  select(';', from: "Separador de campos")
end

feature "Preview CSV", :js do
  let(:user){create(:confirmed_user)}

  scenario 'csv with header' do
    start_creating_transmission_request_with_csv('simple_sms_with_header.csv')
    uncheck("Títulos das colunas na primeira linha")

    expect(all('table.csv-preview tbody tr').size).to eq 3
    check("Títulos das colunas na primeira linha")

    expect(page).to have_content('Mensagem de teste 1')
    expect(page).to have_content('Mensagem de teste 2')
    expect(page).to have_content('11960758475')
    expect(all('table.csv-preview thead th').size).to eq 2
    expect(all('table.csv-preview tbody tr').size).to eq 2
    expect(all('table.csv-preview thead th').map{|th| th.text}).to eq %w[numero mensagem]
  end

  scenario 'csv without header' do
    start_creating_transmission_request_with_csv('simple_sms.csv')
    uncheck("Títulos das colunas na primeira linha")
    expect(page).to have_content('Mensagem de teste 1')
    expect(page).to have_content('Mensagem de teste 2')
    expect(page).to have_content('11960758475')
    expect(all('table.csv-preview thead th').size).to eq 2
    expect(all('table.csv-preview tbody tr').size).to eq 2
    expect(all('table.csv-preview thead th').map{|th| th.text}).to eq %w[A B]
  end
end

feature "CSV Estimations", :js do
  let(:user){create(:confirmed_user)}

  scenario 'csv with header' do
    start_creating_transmission_request_with_csv('large_sms_with_header.csv')
    click_on("Próximo passo");
    # Message step
    check("Usar mensagem de uma coluna?")
    select("B", from: "Coluna das mensagens")
    select("A", from: "Coluna dos telefones")

    click_on("Próximo passo");
    select("Horário Comercial (08:00 às 19:00)", from: 'Horários válidos')
    click_on("Próximo passo");

    expect(page).to have_content('500 mensagens')
  end
  scenario 'csv without header' do
    start_creating_transmission_request_with_csv('large_sms.csv')
    click_on("Próximo passo");
    # Message step
    check("Usar mensagem de uma coluna?")
    select("B", from: "Coluna das mensagens")
    select("A", from: "Coluna dos telefones")
    click_on("Próximo passo");
    select("Horário Comercial (08:00 às 19:00)", from: 'Horários válidos')
    click_on("Próximo passo");
    expect(page).to have_content('750 mensagens')
  end
end

feature "Send CSV" , :js do
  let(:user){create(:confirmed_user)}

  scenario 'simple without headers with message on field' do
    Sidekiq::Testing.fake!
    sign_in user
    click_on('Relatórios')
    click_on('Enviar lote')

    attach_file('Arquivo', File.absolute_path(fixture_file('simple_sms.csv')))
    click_on("Próximo passo");

    # Parse step
    #select('csv', from: "Tipo de arquivo")
    expect(page.has_select?("Tipo de arquivo", selected: 'csv')).to be_truthy
    expect(page.has_select?("Separador de campos", selected: ';')).to be_truthy
    uncheck("Títulos das colunas na primeira linha")
    click_on("Próximo passo");

    # Message step
    check("Usar mensagem de uma coluna?")
    select("B", from: "Coluna das mensagens")
    select("A", from: "Coluna dos telefones")
    click_on("Próximo passo");

    # Schedule step
    ini = "2020/10/10 12:13"
    fin = "2020/10/11 12:13"
    page.execute_script("$('#transmission_request_options_schedule_start_time').val('#{ini}')")
    page.execute_script("$('#transmission_request_options_schedule_finish_time').val('#{fin}')")
    select("Horário Comercial (08:00 às 19:00)", from: 'Horários válidos')
    click_on("Próximo passo");

    # Confirmar step
    expect(page).to have_content('"Mensagem de teste 1"')
    expect(page).to have_content('3 mensagens')


    click_on("Confirmar");
    expect(page).to have_content('Requisição criada com sucesso')
  end


  scenario 'simple with headers with message on field' do
    Sidekiq::Testing.fake!
    sign_in user
    click_on('Relatórios')
    click_on('Enviar lote')

    attach_file('Arquivo', File.absolute_path(fixture_file('simple_sms_with_header.csv')))
    click_on("Próximo passo");

    # Parse step
    #select('csv', from: "Tipo de arquivo")
    expect(page.has_select?("Tipo de arquivo", selected: 'csv')).to be_truthy
    expect(page.has_select?("Separador de campos", selected: ';')).to be_truthy
    check("Títulos das colunas na primeira linha")
    click_on("Próximo passo");

    # Message step
    check("Usar mensagem de uma coluna?")
    select("mensagem", from: "Coluna das mensagens")
    select("numero", from: "Coluna dos telefones")

    # Message step
    click_on("Próximo passo");

    # Schedule step
    ini = "2020/10/10 12:13"
    fin = "2020/10/11 12:13"
    page.execute_script("$('#transmission_request_options_schedule_start_time').val('#{ini}')")
    page.execute_script("$('#transmission_request_options_schedule_finish_time').val('#{fin}')")
    select("Horário Comercial (08:00 às 19:00)", from: 'Horários válidos')
    click_on("Próximo passo");

    # Confirmar step
    expect(page).to have_content('"Mensagem de teste 1"')
    expect(page).to have_content('3 mensagens')


    click_on("Confirmar");
    expect(page).to have_content('Requisição criada com sucesso')
  end




  scenario 'simple without headers with message defined by user' do
    Sidekiq::Testing.fake!
    sign_in user
    click_on('Relatórios')
    click_on('Enviar lote')

    attach_file('Arquivo', File.absolute_path(fixture_file('simple_sms.csv')))
    click_on("Próximo passo");

    # Parse step
    expect(page.has_select?("Tipo de arquivo", selected: 'csv')).to be_truthy
    expect(page.has_select?("Separador de campos", selected: ';')).to be_truthy
    uncheck("Títulos das colunas na primeira linha")
    click_on("Próximo passo");

    # Message step
    uncheck("Usar mensagem de uma coluna?")
    fill_in('Mensagem customizada', with: "Caro cliente do banco Nacional, informamos que nossas funções foram encerradas há tempos.")
    select("A", from: "Coluna dos telefones")

    # Message step
    click_on("Próximo passo");

    # Schedule step
    ini = "2020/10/10 12:13"
    fin = "2020/10/11 12:13"
    page.execute_script("$('#transmission_request_options_schedule_start_time').val('#{ini}')")
    page.execute_script("$('#transmission_request_options_schedule_finish_time').val('#{fin}')")
    select("Horário Comercial (08:00 às 19:00)", from: 'Horários válidos')
    click_on("Próximo passo");

    # Confirmar step
    expect(page).to have_content('Caro cliente do banco Nacional')


    click_on("Confirmar");
    expect(page).to have_content('Requisição criada com sucesso')
  end

  scenario "reject unknown type" , :js do
    sign_in user
    click_on('Relatórios')
    click_on('Enviar lote')

    attach_file('Arquivo', File.absolute_path(__FILE__))
    expect(page.driver.browser.switch_to.alert.text).to have_content("Tipo de arquivo inválido")
  end
end
