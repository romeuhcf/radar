require 'rails_helper'
require 'phone_number_utils'


describe PhoneNumberUtils do

  describe "valid_mobile_number?" do
    it { expect(subject.valid_mobile_number?('1')).to be_falsey }
    it { expect(subject.valid_mobile_number?('9')).to be_falsey }
    it { expect(subject.valid_mobile_number?('9a8')).to be_falsey }

    it { expect(subject.valid_mobile_number?('55 9999 8888')).to be_truthy }
    it { expect(subject.valid_mobile_number?('55 9 9999 8888')).to be_falsey }
    it { expect(subject.valid_mobile_number?('11 9 9999 8888')).to be_truthy }
    it { expect(subject.valid_mobile_number?('11960758444')).to be_truthy }

    it { expect(subject.valid_mobile_number?('+5511960758444')).to be_truthy }
    it { expect(subject.valid_mobile_number?('+55 55 9075 8444')).to be_truthy }
    it { expect(subject.valid_mobile_number?('5511960758444')).to be_truthy }
    it { expect(subject.valid_mobile_number?('555590758444')).to be_truthy }
    it { expect(subject.valid_mobile_number?('1134448833')).to be_falsey }
  end

  describe "with_country_code" do
    it { expect(subject.with_country_code('11960758475')).to eq '5511960758475' }
    it { expect(subject.with_country_code('5511960758475')).to eq '5511960758475' }
    it { expect(subject.with_country_code('58475')).to eq '58475' }
  end

  describe "remove_country_prefix" do
    it{ expect(subject.remove_country_prefix('11960758475')).to eq '11960758475' }
    it{ expect(subject.remove_country_prefix('5511960758475')).to eq '11960758475' }
    describe "ddd 55 " do
    it{ expect(subject.remove_country_prefix('55960758475')).to eq '55960758475' }
    it{ expect(subject.remove_country_prefix('5555960758475')).to eq '55960758475' }
    it{ expect(subject.remove_country_prefix('555560758475')).to eq '5560758475' }
    it{ expect(subject.remove_country_prefix('55960758475')).to eq '55960758475' }
    it{ expect(subject.remove_country_prefix('5560758475')).to eq '5560758475' }
    end
  end
end
