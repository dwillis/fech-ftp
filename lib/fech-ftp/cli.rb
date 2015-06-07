require 'thor'
require 'pry'
module Fech
  class CLI < Thor
    include CLIFileHelper

    desc "Download individual records to <DIR> by specified election year", "Download individual records by year"
    # fech-ftp download candidate --subtable=contribution --format=csv -y 2012 -d ~/Matt/Downloads
    method_option :format, :type => :string, :require => true, :alias => "-f"
    method_option :subtable, :type => :string, :alias => "-s", :default => ''
    method_option :year, :type => :numeric, :require => true, :alias => "-y"
    method_option :destination, :type => :string, :alias => '-d', :default => '.'

    def download(table_name)
      @table = TableProperties.new(table_name, options)
      download_table_data
    end
  end
end
