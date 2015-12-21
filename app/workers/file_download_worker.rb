require 'fileutils'
require 'stringio'

require 'ftp_connection'

class FileDownloadWorker < ActiveJob::Base
  queue_as :file_download

  def test_connection(transfer_bot)
    cfg         = transfer_bot.ftp_config
    host        = cfg.host
    port        = (cfg.port || 21).to_i
    user        = cfg.user
    secret      = cfg.secret
    passive     = cfg.passive?
    remote_path = transfer_bot.remote_path

    output = StringIO.new

    FtpConnection::timeout(10) do
      FtpConnection.start('test_connection', host, port, user, secret, passive, output) do |conn|
        conn.chdir(remote_path)
        conn.list('*')
      end
    end
  end

  def perform(rule_id)
    transfer_bot = TransferBot.find(rule_id)
    begin
      output = StringIO.new
      tmp_path = "/tmp" #TODO defined tmp path

      download(transfer_bot.worker_label, transfer_bot.ftp_config, tmp_path, output) do |tmp, fname|
        fail 'process the file'
        # TODO XXX process the file
      end

      transfer_bot.last_success_at = Time.zone.now
      transfer_bot.status = 'success'
    rescue
      output.puts "Exception #{$!.class}, #{$!.message}"
      $!.backtrace[0,5].each do |l|
        output.puts "\t#{l}"
        transfer_bot.last_failed_at = Time.zone.now
        transfer_bot.status = 'failed'
      end
    ensure
      output.rewind
      transfer_bot.last_log = output.string
      transfer_bot.whodunnit(self.class.name) { transfer_bot.save! }
    end
  end

  def download(label, cfg, patterns, remote_path, tmp_path, output)
    FileUtils.mkdir_p(tmp_path)

    host = cfg.host
    port = (cfg.port || 21).to_i
    user = cfg.user
    secret = cfg.secret
    passive = cfg.passive && true
    remotely_delete_after = cfg.source_delete_after

    output.puts "(#{label})\t CONNECTING... host=#{host}, port=#{port}, user=#{user} , secret=#{'*' * secret.size} , passive=#{passive}"
    FtpConnection.start(label, host, port, user, secret, passive, output) do |conn|

      listed_files = []
      output.puts "(#{label})\t CONNECTED"
      begin
        FtpConnection::timeout(20){
          conn.chdir(remote_path)
          listed_files = conn.list(patterns)
        }
      rescue Net::FTPTempError, Net::FTPConnectionError
        output.puts ["(#{label})", 'ERRO', $!, host, port].join(' ')
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
