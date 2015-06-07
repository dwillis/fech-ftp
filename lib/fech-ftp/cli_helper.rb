module Fech
  module CLIFileHelper
    def fetch_zip_file
      Net::FTP.open(FTP_SETTINGS['url']) do |ftp|
        begin
          ftp.login
          ftp.get(@table.ftp_path, @table.ftp_destination)
        rescue Net::FTPPermError
          raise 'connection failure'
        end
      end
    end

    def download_table_data
      raise 'Table Not Recognized' if !@table.exist?
      fetch_zip_file if !File.exist?(@table.ftp_destination)
      Zip::File.open(@table.ftp_destination) do |zip|
        @table << zip.first.get_input_stream
      end

      # to do - add feature to delete file depending on option
      @table.export
    end
  end
end
