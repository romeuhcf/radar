require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#suspended?' do
    it{ expect(subject).to respond_to(:suspended?) }
    before do
      subject.build_transmission_request(status: 'paused')
    end

    context 'when request is paused' do
      it {expect(subject).to be_suspended }
    end
  end
end
