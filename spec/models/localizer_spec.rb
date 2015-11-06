require 'rails_helper'

RSpec.describe Localizer, type: :model do
  let(:m1) { create(:message) }
  let(:m2) { create(:message) }

  before do
    m1.create_localizer(uid: 'abcd')
    m2.create_localizer(uid: 'efgh')
  end

  it "finds related stuff by hash" do
    expect(Localizer.get_item('abcd')).to eq m1
    expect(Localizer.get_item('efgh')).to eq m2
    expect(Localizer.get_item('aaaa')).to be_nil
  end

  it "can be used on related item" do
    expect(Message.find_by_localizer('efgh')).to eq m2
  end
end
