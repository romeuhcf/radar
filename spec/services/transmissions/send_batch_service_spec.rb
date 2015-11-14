require 'rails_helper'
require 'generators'
describe ::Transmissions::SendBatchService do
  let(:destination_generator) { DestinationGenerator::List.new(%w{11960758475  11961110000}) }
  let(:content_generator)     { ContentGenerator::Static.new("Ave Maria..." ) }
  let(:schedule_generator)    { ScheduleGenerator::Now.new }

  let(:user)        { create(:user) }
  let(:owner)       { user }
  let(:division)    { create(:division, owner: owner)}

  let!(:route_provider){ create(:route_provider) }
  let(:transmission_request) { subject.generate_request("an automated test", content_generator, destination_generator, schedule_generator, user, owner) }

  it { expect(transmission_request.messages.size).to eq 2 }
  it { expect(transmission_request.owner).to eq owner }
  it { expect(transmission_request.user).to eq user }
  it { expect(transmission_request.messages.first.destination.address).to eq "+5511960758475" }
  it { expect(transmission_request.messages.first.message_content.content).to eq "Ave Maria..." }
end
