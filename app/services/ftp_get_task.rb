require 'fileutils'
require 'stringio'
require 'ftp_connection'

class FtpGetTask
  def perform(transfer_options, label='-', output = StringIO.new)
    @output = output
    label ||= transfer_options['server']

    server = transfer_options['server']
    port = (transfer_options['port'] || 21).to_i
    user = transfer_options['user']
    pwd = transfer_options['pwd']
    passive = transfer_options['passive'] && true
    remote_path = transfer_options['remote_path']
    patterns = transfer_options['patterns']
    local_path = transfer_options['local_path'] # TODO make this a temporary path
    remote_delete_after = transfer_options['remote_delete_after']

    FileUtils.mkdir_p(local_path)
    @output.puts "(#{label})\t CONNECTING... server=#{server}, port=#{port}, user=#{user} , pwd=#{pwd} , passive=#{passive}"
    FtpConnection.start(label, server, port, user, pwd, passive, @output) do |conn|

      listed_files = []
      @output.puts "(#{label})\t CONNECTED"
      begin
        FtpConnection::timeout(20){
          conn.chdir(remote_path)
          listed_files = conn.list(patterns)
        }
      rescue Net::FTPTempError, Net::FTPConnectionError
        @output.puts ["(#{label})", 'ERRO', $!, server, port].join(' ')
        return
      end

      @output.puts "(#{label})\t LISTED (#{remote_path}) #{listed_files.size} entries (#{patterns})"
      listed_files.each_with_index do |entry, i|
        dest_file = File.join(local_path, entry)
        tmp_dest_file = dest_file+'.part'

        conn.download(entry, tmp_dest_file) do
          if remote_delete_after
            conn.delete(entry)
            @output.puts "(#{label})\t Remotely deleted [#{entry}]"
          end

          @output.puts "(#{label})\t DOWNLOADED #{i+1} of #{listed_files.size}: [#{entry}] (#{patterns})"
          yield tmp_dest_file, dest_file
        end

      end
      @output.puts "(#{label})\t FULL DOWNLOADED  #{listed_files.size} (#{patterns})"
    end
    @output
  end

  def process_file_after_download(process_options, tmp_dest_file, dest_file, label, output)
    fail "Not implemented " # XXX TODO
  end
end

