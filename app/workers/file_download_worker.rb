require 'fileutils'
require 'stringio'

require 'ftp_connection'

class FileDownloadWorker < ActiveJob::Base
  queue_as :file_download

  def test_connection(rule)
    cfg = rule.transfer_options
    server = cfg['server']
    port = (cfg['port'] || 21).to_i
    user = cfg['user']
    pwd = cfg['pwd']
    passive = cfg['passive'] && true
    remote_path = cfg['remote_path']

    output = StringIO.new
    FtpConnection.start('test_connection', server, port, user, pwd, passive, output) do |conn|
      FtpConnection::timeout(10){
        conn.chdir(remote_path)
        conn.list('*')
      }
    end
  end

  def perform(rule_id)
    rule = FileDownloadRule.find(rule_id)
    begin
      output = StringIO.new
      tmp_path = "/tmp" #XXX defined tmp path

      download(rule.worker_label, rule.process_options, tmp_path, output) do |tmp, fname|
        fail 'process the file'
        # ToDO XXX process the file
      end

      rule.last_success_at = Time.zone.now
      rule.status = 'success'
    rescue
      output.puts "Exception #{$!.class}, #{$!.message}"
      $!.backtrace[0,5].each do |l|
        output.puts "\t#{l}"
        rule.last_failed_at = Time.zone.now
        rule.status = 'failed'
      end
    ensure
      rule.last_log = output.rewind.string
      rule.whodunnit(self.class.name) { rule.save! }
    end
  end

  def download(label, cfg, tmp_path, output)
    FileUtils.mkdir_p(tmp_path)
    server = cfg['server']
    port = (cfg['port'] || 21).to_i
    user = cfg['user']
    pwd = cfg['pwd']
    passive = cfg['passive'] && true
    remote_path = cfg['remote_path']
    patterns = cfg['patterns']
    remotely_delete_after = cfg['remotely_delete_after']

    output.puts "(#{label})\t CONNECTING... server=#{server}, port=#{port}, user=#{user} , pwd=#{'*' * pwd.size} , passive=#{passive}"
    FtpConnection.start(label, server, port, user, pwd, passive, output) do |conn|

      listed_files = []
      output.puts "(#{label})\t CONNECTED"
      begin
        FtpConnection::timeout(20){
          conn.chdir(remote_path)
          listed_files = conn.list(patterns)
        }
      rescue Net::FTPTempError, Net::FTPConnectionError
        output.puts ["(#{label})", 'ERRO', $!, server, port].join(' ')
        return
      end

      output.puts "(#{label})\t LISTED (#{remote_path}) #{listed_files.size} entries (#{patterns})"
      listed_files.each_with_index do |entry, i|
        dest_file = File.join(tmp_path, entry)
        tmp_dest_file = dest_file+'.tmp'

        conn.download(entry, tmp_dest_file) do
          if remotely_delete_after
            conn.delete(entry)
            output.puts "(#{label})\t REMOTELY DELETED #{entry}"
          end

          output.puts "(#{label})\t DOWNLOADED #{i+1} of #{listed_files.size}: [#{entry}] (#{patterns})"
          yield tmp_dest_file, dest_file
        end

      end
      output.puts "(#{label})\t FULL DOWNLOADED  #{listed_files.size} (#{patterns})"
    end
  end
end
