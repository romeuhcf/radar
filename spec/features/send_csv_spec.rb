require 'rails_helper'


def start_creating_transmission_request_with_csv(basename)
  sign_in user
  click_on('Relatórios')
  click_on('Enviar lote')

  attach_file('Batch file', File.absolute_path(fixture_file(basename)))
  click_on("Próximo passo");

  # Parse step
  select('csv', from: "File type")
  select(';', from: "Field separator")
end

feature "Preview CSV", :js do
  let(:user){create(:confirmed_user)}

  scenario 'csv with header' do
    start_creating_transmission_request_with_csv('simple_sms_with_header.csv')
    uncheck("Headers at first line")

    expect(all('table.csv-preview tbody tr').size).to eq 3
    check("Headers at first line")

    expect(page).to have_content('Mensagem de teste 1')
    expect(page).to have_content('Mensagem de teste 2')
    expect(page).to have_content('11960758475')
    expect(all('table.csv-preview thead th').size).to eq 2
    expect(all('table.csv-preview tbody tr').size).to eq 2
    expect(all('table.csv-preview thead th').map{|th| th.text}).to eq %w[numero mensagem]
  end

  scenario 'csv without header' do
    start_creating_transmission_request_with_csv('simple_sms.csv')
    uncheck("Headers at first line")
    expect(page).to have_content('Mensagem de teste 1')
    expect(page).to have_content('Mensagem de teste 2')
    expect(page).to have_content('11960758475')
    expect(all('table.csv-preview thead th').size).to eq 2
    expect(all('table.csv-preview tbody tr').size).to eq 2
    expect(all('table.csv-preview thead th').map{|th| th.text}).to eq %w[1 2]
  end
end

feature "CSV Estimations", :js do
  let(:user){create(:confirmed_user)}

  scenario 'csv with header' do
    start_creating_transmission_request_with_csv('large_sms_with_header.csv')
    click_on("Próximo passo");
    # Message step
    check("Message defined at column")
    select("2", from: "Column of message")
    select("1", from: "Column of number")

    click_on("Próximo passo");
    click_on("Confirm");

    expect(page).to have_content('500 mensagens')
  end
  scenario 'csv without header' do
    start_creating_transmission_request_with_csv('large_sms.csv')
    click_on("Próximo passo");
    # Message step
    check("Message defined at column")
    select("2", from: "Column of message")
    select("1", from: "Column of number")
    click_on("Próximo passo");
    click_on("Confirm")
    expect(page).to have_content('750 mensagens')
  end
end

feature "Send CSV" , :js do
  let(:user){create(:confirmed_user)}

  scenario 'simple without headers with message on field' do
    sign_in user
    click_on('Relatórios')
    click_on('Enviar lote')

    attach_file('Batch file', File.absolute_path(fixture_file('simple_sms.csv')))
    click_on("Próximo passo");

    # Parse step
    #select('csv', from: "File type")
    expect(page.has_select?("File type", selected: 'csv')).to be_truthy
    expect(page.has_select?("Field separator", selected: ';')).to be_truthy
    uncheck("Headers at first line")
    click_on("Próximo passo");

    # Message step
    check("Message defined at column")
    select("2", from: "Column of message")
    select("1", from: "Column of number")

    # Message step
    click_on("Próximo passo");

    # Schedule step
    ini = "2020/10/10 12:13"
    fin = "2020/10/11 12:13"
    page.execute_script("$('#transmission_request_options_schedule_start_time').val('#{ini}')")
    page.execute_script("$('#transmission_request_options_schedule_finish_time').val('#{fin}')")
    select("Business hours", from: 'Timing table')
    click_on("Próximo passo");

    # Confirm step
    expect(page).to have_content('"Mensagem de teste 1"')
    expect(page).to have_content('3 mensagens')


    click_on("Confirmar");
    expect(page).to have_content('Requisição criada com sucesso')
  end


  scenario 'simple with headers with message on field' do
    sign_in user
    click_on('Relatórios')
    click_on('Enviar lote')

    attach_file('Batch file', File.absolute_path(fixture_file('simple_sms_with_header.csv')))
    click_on("Próximo passo");

    # Parse step
    #select('csv', from: "File type")
    expect(page.has_select?("File type", selected: 'csv')).to be_truthy
    expect(page.has_select?("Field separator", selected: ';')).to be_truthy
    check("Headers at first line")
    click_on("Próximo passo");

    # Message step
    check("Message defined at column")
    select("mensagem", from: "Column of message")
    select("numero", from: "Column of number")

    # Message step
    click_on("Próximo passo");

    # Schedule step
    ini = "2020/10/10 12:13"
    fin = "2020/10/11 12:13"
    page.execute_script("$('#transmission_request_options_schedule_start_time').val('#{ini}')")
    page.execute_script("$('#transmission_request_options_schedule_finish_time').val('#{fin}')")
    select("Business hours", from: 'Timing table')
    click_on("Próximo passo");

    # Confirm step
    expect(page).to have_content('"Mensagem de teste 1"')
    expect(page).to have_content('3 mensagens')


    click_on("Confirmar");
    expect(page).to have_content('Requisição criada com sucesso')
  end




  scenario 'simple without headers with message defined by user' do
    sign_in user
    click_on('Relatórios')
    click_on('Enviar lote')

    attach_file('Batch file', File.absolute_path(fixture_file('simple_sms.csv')))
    click_on("Próximo passo");

    # Parse step
    expect(page.has_select?("File type", selected: 'csv')).to be_truthy
    expect(page.has_select?("Field separator", selected: ';')).to be_truthy
    uncheck("Headers at first line")
    click_on("Próximo passo");

    # Message step
    uncheck("Message defined at column")
    fill_in('Custom message', with: "Caro cliente do banco Nacional, informamos que nossas funções foram encerradas há tempos.")
    select("1", from: "Column of number")

    # Message step
    click_on("Próximo passo");

    # Schedule step
    ini = "2020/10/10 12:13"
    fin = "2020/10/11 12:13"
    page.execute_script("$('#transmission_request_options_schedule_start_time').val('#{ini}')")
    page.execute_script("$('#transmission_request_options_schedule_finish_time').val('#{fin}')")
    select("Business hours", from: 'Timing table')
    click_on("Próximo passo");

    # Confirm step
    expect(page).to have_content('Caro cliente do banco Nacional')


    click_on("Confirmar");
    expect(page).to have_content('Requisição criada com sucesso')
  end

  scenario "reject unknown type" , :js do
    sign_in user
    click_on('Relatórios')
    click_on('Enviar lote')

    attach_file('Batch file', File.absolute_path(__FILE__))
    expect(page.driver.browser.switch_to.alert.text).to have_content("Tipo de arquivo inválido")
  end
end
