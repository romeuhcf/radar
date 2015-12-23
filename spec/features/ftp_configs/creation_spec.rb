require 'rails_helper'

feature "FTP configs creation" do
  let(:user){create(:confirmed_user)}
  before do
    sign_in user
    click_on "Acessos FTP"
    click_on "Novo acesso FTP"
  end

  scenario "simple record" do
    fill_in "Servidor", with: "ftp.demec.ufpr.br"
    fill_in "Porta", with: "21"
    fill_in "Usuário", with: "anonymous"
    fill_in "Senha", with: "anonymous"
    click_on "Salvar"
    expect(page).to have_content('Acesso FTP foi criado com sucesso')
  end
end
