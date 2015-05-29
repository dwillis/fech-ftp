require 'thor'
require 'pry'
module Fech
  class TableProperties
    def initialize(properties={})
      @destination = properties[:dest]
      @filename    = properties[:file]
      @year        = properties[:year]
      @col_headers = properties[:headers]
      @format      = properties[:format]
      @lines       = []
    end

    def save_file?
      @format[:keep]
    end

    def ftp_destination
      "#{@destination}/#{@filename}.zip"
    end

    def txt_file
      "#{@destination}/#{@filename}.txt"
    end

    def ftp_path
      "./FEC/#{@year.to_s[2..3]}/#{@filename}.zip"
    end

    def <<(stream)
      stream.readlines.each do |ln|
        line = ln.split("|").pop
        @lines << Hash[@col_headers.zip line]
      end
    end

    def export
      case object
      when condition

      end
    end
  end

  module CLIFileHelper
    def download_table_data(properties)
      @table = TableProperties.new(properties)
      Net::FTP.open("ftp.fec.gov") do |ftp|
        begin
          ftp.login
          ftp.get(@table.ftp_path, @table.ftp_destination)
        rescue Net::FTPPermError
          raise 'connection failure'
        end
      end

      Zip::File.open(@table.zip_path) do |zip|
        @table << zip.first.get_input_stream
      end

      @table.export
    end
  end

  class CLI < Thor
    include Fech::CLIFileHelper
    # fech-ftp download individual 2012 --detail=format:csv
    # fech-ftp download committee -c 2012 --format=csv
    desc "Download individual records to <DIR> by specified election year", "Download individual records by year"
    method_option :format, :type => :string, :require => true, :alias => "-f"
    method_option :contributions, :alias => "-c", :default => ""
    method_option :year, :type => :numeric, :require => true, :alias => "-y"

    def download(table_name, subtable, dest=".")
      options.map! { |k,v| options[k.to_sym] = v }
      table_name = "#{table_name.capitalize}#{options[:contributions].capitalize}"
      if Fech.const_defined?(table_name)
        headers = Fech.get_const("#{table_name}::HEADERS")
        if !headers.key?(:file)
          headers = headers[subtable.to_sym]
        end
      else
        raise 'some error'
      end

      properties = headers.merge(options)
      download_table_data(properties)
      # with the first argument in the CLI command, a class pertaining to it is found
      # and returned as a constant.
      # FEC GET -> get zip file
      # FEC EXRACT AND PARSE -> extract zip file and parse
      # FEC EXPORT -> export into desired format
      # FEC CLEANUP -> cleanup settings (i.e. remove downloaded file, etc)
      # a check is made to ensure the correct sub-table was found
      # The table gets initialized with the passed attributes
    end
  end
end
