require 'rails_helper'

describe Transmissions::ResumeBatchService do
  let!(:response) {subject.resume_transmission_request(request)}
  context 'try to resume' do
    context 'when request is paused' do
      let(:request) {TransmissionRequest.create!(status: :paused, messages: [Message.create!])}
      it {expect(response).to be_truthy }
      it {expect(request.reload).to_not be_paused }
      it {expect(request.reload).to be_processing }
      it {expect(request.pending_messages.all?{|m| m.suspended?}).to be_falsey}
    end

    context 'when request is cancelled' do
      let(:request) {TransmissionRequest.create!(status: :cancelled, messages: [Message.create!])}
      it {expect(response).to be_falsey }
      it {expect(request.reload).to_not be_processing }
    end

    context 'when request is finished' do
      let(:request) {TransmissionRequest.create!(status: :finished, messages: [Message.create!])}
      it {expect(response).to be_falsey }
      it {expect(request.reload).to_not be_processing }
    end

    context 'when request is failed' do
      let(:request) {TransmissionRequest.create!(status: :failed, messages: [Message.create!])}
      it {expect(response).to be_falsey }
      it {expect(request.reload).to_not be_processing }
    end

    context 'when request is processing' do
      let(:request) {TransmissionRequest.create!(status: :processing, messages: [Message.create!])}
      it {expect(response).to be_falsey }
      it {expect(request.reload).to be_processing }
      it {expect(request.pending_messages.size).to eq 1}
      it {expect(request.pending_messages.all?{|m| m.suspended?}).to be_falsey}
    end
  end
end
