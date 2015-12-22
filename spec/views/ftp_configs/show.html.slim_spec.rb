require 'rails_helper'

RSpec.describe "ftp_configs/show", type: :view do
  before(:each) do
    @ftp_config = assign(:ftp_config, create(:ftp_config))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Servidor/)
    expect(rendered).to match(/Porta/)
    expect(rendered).to match(/Usuário/)
    expect(rendered).to match(/Senha/)
    expect(rendered).to match(/false/)
  end
end
