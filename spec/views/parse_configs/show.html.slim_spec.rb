require 'rails_helper'

RSpec.describe "parse_configs/show", type: :view do
  before(:each) do
    @parse_config = assign(:parse_config,create(:parse_config))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Tipo de arquivo/)
    expect(rendered).to match(/Descrição/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Coluna das mensagens/)
    expect(rendered).to match(/Coluna dos telefones/)
    expect(rendered).to match(/Coluna das referências do destinatário/)
    expect(rendered).to match(/Início/)
    expect(rendered).to match(/Fim/)
    expect(rendered).to match(/Horários válidos/)
    expect(rendered).to match(/Separador de campos/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
  end
end
