=begin
require 'net/ftp'
require 'timeout'
require 'fileutils'
require 'file_list_filter'

require 'ftp_connection'
require 'file_list_filter'
require 'stringio'

class FtpPutWorker

  def perform(cfg, label=nil, output=StringIO.new)
    label ||= cfg['server']
    server = cfg['server']
    port = cfg['port']
    user = cfg['user']
    pwd = cfg['pwd']
    passive = cfg['passive']
    remote_path = cfg['remote_path']
    patterns = cfg['patterns']
    local_path = cfg['local_path']
    delete_after = cfg['delete_after']
    after_transmission = cfg['after_transmission']
    @output=output

    FtpConnection.start(label, server, port, user, pwd, passive,@output) do |conn|

      listed_files = FileListFilter.filter(patterns, Dir[File.join(local_path, '*')].collect{|e|File.basename(e)} )
      @output.puts "(#{label})\t CONNECTED"
      begin
        Timeout::timeout(20){
          conn.chdir(remote_path)
        }
      rescue Net::FTPTempError, Net::FTPConnectionError
        @output.puts ["(#{label})", 'ERRO', $!, server, port].join(' ')
        return
      end

      @output.puts "(#{label})\t LOCAL LISTED (#{local_path}) #{listed_files.size} entries (#{patterns})"
      listed_files.each_with_index do |entry, i|
        # TODO... upload to .part then rename remote
        conn.upload(entry, local_path) do #|tmp_dest_file, dest_file|
          @output.puts "(#{label})\t UPLOADED #{i+1} of #{listed_files.size}: [#{entry}] (#{patterns})"

#          if after_transmission
#            @output.puts "(#{label}) lambda after download"
#            after_transmission.constantize.call(tmp_dest_file, dest_file, label, @output)
#          else
            File.unlink(File.join(local_path, entry)) if delete_after
#          end

        end
      end

    end
    @output
  end
end
=end
