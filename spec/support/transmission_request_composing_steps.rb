def compose_transmission_request_until_step(step =nil, file = nil)
  sign_in user
  click_on('Enviar Lote')
  return if step.nil?

  attach_file('Arquivo', File.absolute_path(fixture_file(file||'simple_sms.csv')))
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
  page.execute_script("$('#transmission_request_schedule_span_config_attributes_start_time').val('#{ini}')")
  page.execute_script("$('#transmission_request_schedule_span_config_attributes_finish_time').val('#{fin}')")
  select("Horário Comercial (08:00 às 19:00)", from: 'Horários válidos')
  click_on("Próximo passo")
  return if step == 'schedule'

  # Confirmar step
  expect(page).to have_content('"Mensagem de teste 1"')
  expect(page).to have_content('3 mensagens')
  return if step == 'confirm'
end
