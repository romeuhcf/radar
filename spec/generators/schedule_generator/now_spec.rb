require 'rails_helper'
describe ScheduleGenerator::Now do
  describe '#generate' do
    it {expect((subject.generate - Time.current).to_i).to eq 0 }
  end
end
