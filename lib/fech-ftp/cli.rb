require 'thor'
require 'pry'
module Fech
  class CLI < Thor
    include CLIFileHelper

    desc "Download individual records to <DIR> by specified election year", "Download individual records by year"
    method_option :format, :type => :string, default: 'to_rb_obj', :alias => "-f"
    method_option :year, :type => :numeric, :require => true, :alias => "-y"

    def download(table_name, category='all', destination='.')
      # grab the tables from the constant
      fec_tables = FTP_SETTINGS['tables']
      # check to be sure that the table supplied exists
      if fec_tables[table_name.downcase].nil?
        raise Fech::InvalidTable, table_name
      end

      if !Dir.exist?(destination)
        raise 'invalid file path'
      end

      # if a category was specified,
      if category != 'all'
        fec_tables = fec_tables[table_name.downcase].select { |table| table['category'] == category.downcase }
      else
        fec_tables = fec_tables[table_name.downcase]
      end

      raise Fech::InvalidTable, "#{category} of #{table_name}" if fec_tables.empty?
      process_request(fec_tables, destination, options)
    end

    desc 'show help menu', 'help information'
    def help
      msg =
        """
          Available Tables (and categories & examples):
            1. candidate -> detail, summary and current
              | $ fech-ftp download candidate --category=current --year=2012 --format=csv
            2. committee -> detail, link, summary, current
              | $ fech-ftp download committee category=link --year=2010
            3. individual -> summary
              | $ fech-ftp download individual category=summary --year=2008 --format=csv

          to use, pick one of the above three table names, followed by a category (separated by a colon)

        """
      puts msg
    end
  end
end
