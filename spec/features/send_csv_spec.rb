require 'rails_helper'

feature "Send CSV" , :js do
  let(:user){create(:confirmed_user)}

  scenario 'simple without headers with message on field' do
    sign_in user
    click_on('Relatórios')
    click_on('Enviar lote')

    attach_file('Batch file', File.absolute_path(fixture_file('simple_sms.csv')))
    click_on("Próximo passo");

    select('csv', from: "File type")
    select(';', from: "Field separator")
    uncheck("Headers at first line")
    click_on("Próximo passo");

    check("Message defined at column")
    select("2", from: "Column of message")
    click_on("Próximo passo");
    ini = "2020/10/10 12:13"
    fin = "2020/10/11 12:13"
    page.execute_script("$('#transmission_request_options_schedule_start_time').val('#{ini}')")
    page.execute_script("$('#transmission_request_options_schedule_finish_time').val('#{fin}')")
    select("Business hours", from: 'Timing table')
    click_on("Próximo passo");

    click_on("Confirmar");
    expect(page).to have_content('Requisição criada com sucesso')
  end
end
