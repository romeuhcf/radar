require 'rails_helper'

describe LiquidTemplateService do

  let(:data){
    {nome: 'Joao da Cunha'}
  }

  context 'template' do
    let(:template){"Caro {{nome}}, tudo bem?"}
    subject {described_class.new(template)}
    it {expect(subject.render(data)).to eq 'Caro Joao da Cunha, tudo bem?' }
  end

  context 'template with prinome' do
    let(:templateX){"Caro {{ nome | prinome }}, tudo bem?"}
    subject {described_class.new(templateX)}
    it do
      expect(subject.render(data)).to eq 'Caro Joao, tudo bem?'
    end
  end

  context 'template with prinome' do
    let(:templateY){"Caro {{ nome | palavra: 1 }}, tudo bem?"}
    subject {described_class.new(templateY)}
    it do
      expect(subject.render(data)).to eq 'Caro Joao, tudo bem?'
    end
  end
end
