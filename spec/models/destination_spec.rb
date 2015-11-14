require 'rails_helper'

RSpec.describe Destination, type: :model do

  it "stores phone number in e164 format" do
    destination = create(:destination, address: '11960758475')
    expect(destination.address).to eq '+5511960758475'
  end

  it "refuses to save number without area code" do
    destination = Destination.new(address: '960758475')
    expect(destination).to_not be_valid
    expect(destination.errors[:address].size).to eq 1
  end

  it "accepts number with ddd only" do
    destination = Destination.new(address: '11960758475')
    expect(destination).to be_valid
  end

  it "accepts number with national code " do
    destination = Destination.new(address: '5511960758475')
    expect(destination).to be_valid
  end

  it "accepts number with e164 format" do
    destination = Destination.new(address: '+5511960758475')
    expect(destination).to be_valid
  end
end
