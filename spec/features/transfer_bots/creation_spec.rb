require 'rails_helper'

feature "Transfer bots creation" do
  let(:user){create(:confirmed_user)}
  before do
    sign_in user
    click_on "Robôs de Transmissão"
    click_on "Novo robô de transmissão"
  end

  scenario "simple robot" do
    fill_in "Descrição", with: "ftp teste"
    fill_in "Programação", with: "* * * * *"
    fill_in "Caminho remoto", with: "."
    fill_in "Arquivos", with: "*.txt"
    fill_in "Servidor", with: "ftp.demec.ufpr.br"
    fill_in "Porta", with: "21"
    fill_in "Usuário", with: "anonymous"
    fill_in "Senha", with: "anonymous"
    uncheck("Ativo")
    click_on "Salvar"
    expect(page).to have_content('Robô de transmissão foi criado com sucesso')
  end
end
