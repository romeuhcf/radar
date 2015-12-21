require 'rails_helper'
require 'ftp_connection'

def force_ftp_success_at_codeship
  return unless ENV['CI_NAME'] == 'codeship'
  allow(FtpConnection).to receive(:start) do |label, host, port, user, secret, passive, output|
    fail 'OOPS' unless host == 'ftp.demec.ufpr.br'
  end
end

RSpec.describe TransferBot, type: :model do
  before { force_ftp_success_at_codeship }

  let(:accessible_ftp_server_options){
    {
      'host' => 'ftp.demec.ufpr.br',
      'port' => 21,
      'user' => 'anonymous',
      'secret' => 'anonymous',
      'passive' => true,

    }
  }
  let(:user){create(:user)}
  let(:valid_attributes){ {worker_class: 'FileDownloadWorker', schedule: '* * * * * *', description: "Just a description", ftp_config_attributes: accessible_ftp_server_options, owner: user, remote_path: '.', patterns: '*.txt', enabled: true}}

  it  {expect(described_class.new(valid_attributes)).to be_valid}
  context 'owner' do
    it  {expect(described_class.new(valid_attributes.merge(owner: nil))).to_not be_valid}
  end

  context 'validates worker class' do
    it  {expect(described_class.new(valid_attributes.merge(worker_class: nil))).to_not be_valid}
    it  {expect(described_class.new(valid_attributes.merge(worker_class: 'String'))).to_not be_valid}
    it  {expect(described_class.new(valid_attributes.merge(worker_class: 'FileDownloadWorker'))).to be_valid}
  end

  context 'validates schedule cron format' do
    it  {expect(described_class.new(valid_attributes.merge(schedule: nil))).to_not be_valid}
    it  {expect(described_class.new(valid_attributes.merge(schedule: 'String'))).to_not be_valid}
    it  {expect(described_class.new(valid_attributes.merge(schedule: '* * * * * *'))).to be_valid}
  end

  context 'validates description' do
    it  {expect(described_class.new(valid_attributes.merge(description: nil))).to_not be_valid}
    it  {expect(described_class.new(valid_attributes.merge(description: 'String'))).to be_valid}
  end

  context 'validates ftp connection' do
    it  {expect(described_class.new(valid_attributes.merge({}))).to be_valid}
    it  {expect(described_class.new(valid_attributes.merge(ftp_config_attributes: {}))).to_not be_valid}
    it  {expect(described_class.new(valid_attributes.merge(ftp_config_attributes: accessible_ftp_server_options.merge('host' => 'dont.know')))).to_not be_valid}
  end
end
