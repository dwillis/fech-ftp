require 'thor'
require 'pry'
module Fech
  class CLI < Thor
    include CLIFileHelper

    desc "Download individual records to <DIR> by specified election year", "Download individual records by year"
    # fech-ftp download candidate --subtable=contribution --format=csv -y 2012 -d ~/Matt/Downloads
    method_option :format, :type => :string, default: 'to_rb_obj', :alias => "-f"
    method_option :subtable, :type => :string, :alias => "-s", :default => 'summary'
    method_option :year, :type => :numeric, :require => true, :alias => "-y"
    method_option :destination, :type => :string, :alias => '-d', :default => '.'

    def download(table_name)
      @table = Table.new(table_name, Hash[options.map { |k,v| [k.to_sym, v] }])
      download_table_data

      @table.export
    end
  end
end
