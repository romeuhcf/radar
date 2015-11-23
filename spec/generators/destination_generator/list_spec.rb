require 'rails_helper'

describe DestinationGenerator::List do
  subject{ described_class.new(['11960758475','11988888877'])}
  describe "#total" do
    it { expect(subject.total).to eq 2 }
  end

  describe "#generate(&block)" do
    it do

      datas = []
      subject.generate do |dest_data|
        datas << dest_data
      end

      dest_data = datas[0]
      expect(dest_data).to be_instance_of DestinationData
      expect(dest_data.destination).to be_instance_of Destination
      expect(dest_data.destination).to be_persisted
      expect(dest_data.destination.address).to eq '+5511960758475'

      dest_data = datas[1]
      expect(dest_data).to be_instance_of DestinationData
      expect(dest_data.destination).to be_instance_of Destination
      expect(dest_data.destination).to be_persisted
      expect(dest_data.destination.address).to eq '+5511988888877'
    end

  end
end
