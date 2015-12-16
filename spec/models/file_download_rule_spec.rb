require 'rails_helper'
def force_ftp_success_at_codeship
  return unless ENV['CI_NAME'] == 'codeship'
  allow(FtpConnection).to receive(:start) do |label, server, port, user, pwd, passive, output|
    fail 'OOPS' unless server == 'ftp.unicamp.br'
  end
end

RSpec.describe FileDownloadRule, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  let(:ftp_unicamp_options){
    {
      'server' => 'ftp.unicamp.br',
      'port' => 21,
      'user' => 'anonymous',
      'pwd' => 'anonymous',
      'remote_path' => '/pub'
    }
  }
  let(:user){create(:user)}
  let(:valid_attributes){ {worker_class: 'FileDownloadWorker', schedule: '* * * * * *', description: "Just a description", transfer_options: ftp_unicamp_options, owner: user}}

  it  {expect(described_class.new(valid_attributes)).to be_valid}
  context 'owner' do
    before { force_ftp_success_at_codeship }
    it  {expect(described_class.new(valid_attributes.merge(owner: nil))).to_not be_valid}
  end

  context 'validates worker class' do
    before { force_ftp_success_at_codeship }
    it  {expect(described_class.new(valid_attributes.merge(worker_class: nil))).to_not be_valid}
    it  {expect(described_class.new(valid_attributes.merge(worker_class: 'String'))).to_not be_valid}
    it  {expect(described_class.new(valid_attributes.merge(worker_class: 'FileDownloadWorker'))).to be_valid}
  end

  context 'validates schedule cron format' do
    before { force_ftp_success_at_codeship }
    it  {expect(described_class.new(valid_attributes.merge(schedule: nil))).to_not be_valid}
    it  {expect(described_class.new(valid_attributes.merge(schedule: 'String'))).to_not be_valid}
    it  {expect(described_class.new(valid_attributes.merge(schedule: '* * * * * *'))).to be_valid}
  end

  context 'validates description' do
    before { force_ftp_success_at_codeship }
    it  {expect(described_class.new(valid_attributes.merge(description: nil))).to_not be_valid}
    it  {expect(described_class.new(valid_attributes.merge(description: 'String'))).to be_valid}
  end

  context 'validates ftp connection' do
    before { force_ftp_success_at_codeship }
    it  {expect(described_class.new(valid_attributes.merge(transfer_options: nil))).to_not be_valid}
    it  {expect(described_class.new(valid_attributes.merge(transfer_options: {}))).to_not be_valid}
    it  {expect(described_class.new(valid_attributes.merge(transfer_options: ftp_unicamp_options.merge('server' => 'dont.know')))).to_not be_valid}
  end
end
