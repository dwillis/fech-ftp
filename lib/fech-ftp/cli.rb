require 'thor'
require 'pry'
module Fech
  class TableProperties
    def initialize(table_name, properties={})
      @table       = FTP_SETTINGS['tables'][table_name.downcase]
      @destination = properties['destination']
      @subtable    = properties['subtable']
      @year        = properties['year']
      @format      = properties['format']
      @lines       = []
    end

    def table_attrs
      @table_attrs ||= @table[@subtable]
    end

    # change to table_name from table
    def struct
      @struct ||= Struct.new(table_attrs['table'], *headers) do
        table_attrs['headers'].each do |header|
          if header =~ /contribution/

          elsif header =~ /_date/
            define_method(header, ->(){  })
        end
      end
    end

    def filename
      @filename ||= table_attrs['filename'] + @year.to_s[2..3]
    end

    def ftp_destination
      "#{@destination}/#{filename}.zip"
    end

    def txt_file
      "#{@destination}/#{filename}.txt"
    end

    def ftp_path
      "./FEC/#{@year}/#{filename}.zip"
    end

    def <<(stream)
      stream.readlines.each do |ln|
        line = ln.split("|").pop
        @lines << struct.new(*line)
      end
    end

    def zip_path

    end

    def export
    end

    def export_csv
    end

    def export_db

    end

    def export_objects
    end

    def exist?
      @table.is_a?(Hash) && @table[@subtable].is_a?(Hash)
    end
  end

  module CLIFileHelper
    def download_table_data(table)
      if table.exist?
        binding.pry
      #   Net::FTP.open(FTP_SETTINGS['url']) do |ftp|
      #     begin
      #       ftp.login
      #       ftp.get(table.ftp_path, table.ftp_destination)
      #     rescue Net::FTPPermError
      #       raise 'connection failure'
      #     end
      #   end

        Zip::File.open(table.ftp_destination) do |zip|
          table << zip.first.get_input_stream
        end
        table.export
      else
        raise 'error'
      end
    end
  end

  class CLI < Thor
    include CLIFileHelper

    desc "Download individual records to <DIR> by specified election year", "Download individual records by year"
    # fech-ftp download candidate --subtable=contribution --format=csv -y 2012 -d ~/Matt/Downloads
    method_option :format, :type => :string, :require => true, :alias => "-f"
    method_option :subtable, :type => :string, :alias => "-s", :default => ''
    method_option :year, :type => :numeric, :require => true, :alias => "-y"
    method_option :destination, :type => :string, :alias => '-d', :default => '.'

    def download(table_name)
      download_table_data TableProperties.new(table_name, options)
    end
  end
end
