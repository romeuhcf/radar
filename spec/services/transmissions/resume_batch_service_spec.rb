require 'rails_helper'

describe Transmissions::ResumeBatchService do
  let!(:response) do
    Sidekiq::Testing.fake! do
      subject.resume_transmission_request(request)
    end
  end
  context 'try to resume' do
    context 'when request is paused' do
      let(:request) {create(:transmission_request, status: :paused, size: 1)}
      it {expect(response).to be_truthy }
      it {expect(request.reload).to_not be_paused }
      it {expect(request.reload).to be_processing }
      it {expect(request.pending_messages.all?{|m| m.suspended?}).to be_falsey}
    end

    context 'when request is cancelled' do
      let(:request) {create(:transmission_request, status: :cancelled, size: 1)}
      it {expect(response).to be_falsey }
      it {expect(request.reload).to_not be_processing }
    end

    context 'when request is finished' do
      let(:request) {create(:transmission_request, status: :finished, size: 1)}
      it {expect(response).to be_falsey }
      it {expect(request.reload).to_not be_processing }
    end

    context 'when request is failed' do
      let(:request) {create(:transmission_request, status: :failed, size: 1)}
      it {expect(response).to be_falsey }
      it {expect(request.reload).to_not be_processing }
    end

    context 'when request is processing' do
      let(:request) {create(:transmission_request, status: :processing, size: 1)}
      it {expect(response).to be_falsey }
      it {expect(request.reload).to be_processing }
      it {expect(request.pending_messages.size).to eq 1}
      it {expect(request.pending_messages.all?{|m| m.suspended?}).to be_falsey}
    end
  end
end
