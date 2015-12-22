require 'timeout'
require 'net/ftp'
require 'net/ftp/list'
require 'file_list_filter'

class FtpConnection
  def self.timeout(*args)
    Timeout::timeout(*args) do
      yield
    end
  end

  def self.start(*args)
    instance = timeout(20) {
      self.new(*args)
    }
    yield instance
    instance.close
  end

  def initialize(label, server, port, user, pwd, passive, output, debug = false)
    @output = output
    @label = label
    begin
      @ftp = Net::FTP.new
      @ftp.debug_mode  = debug
      @ftp.connect(server, port)
      @ftp.login(user,pwd)
      @ftp.passive  = passive
    rescue Errno::ETIMEDOUT
      @output.puts ['ERRO', @label, $!, server, port].join(' ')
      sleep 1
    end
  end

  def download(entry, to_path)
    begin
      @ftp.getbinaryfile(entry, to_path)
    rescue Net::FTPPermError, EOFError, Net::FTPProtoError
      @output.puts "OOPS: [#{@label}] on getbinaryfile (#{entry}) " + $!.to_s.strip + "@ pwd #{@ftp.pwd} "
      return
    end
  end

  def upload(entry, local_path)
    local_file = File.join(local_path, entry)
    dest_file = entry
    # tmp_dest_file = dest_file+'.tmp'
    begin
      @ftp.putbinaryfile(local_file, dest_file)
    rescue Net::FTPPermError, EOFError, Net::FTPProtoError
      @output.puts "OOPS: [#{@label}] on putbinaryfile (#{entry}) " + $!.to_s.strip + "@ pwd #{@ftp.pwd} "
      return
    end

    yield #tmp_dest_file, dest_file
    #@ftp.rename(tmp_dest_file, dest_file)
  end

  def delete(entry)
    @ftp.delete(entry)
  end

  def chdir(remote_path)
    @ftp.chdir(remote_path)
  end

  def list(patterns)
    FileListFilter.filter(patterns, @ftp.list('*').collect{|e| Net::FTP::List.parse(e).basename} )
  end

  def close
    @ftp.close
  end
end

