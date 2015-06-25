require 'thor'
require 'pry'
module Fech
  class CLI < Thor
    include CLIFileHelper

    desc "Download individual records to <DIR> by specified election year", "Download individual records by year"
    method_option :format, :type => :string, default: 'to_rb_obj', :alias => "-f"
    method_option :year, :type => :numeric, :require => true, :alias => "-y"
    method_option :server, :type => :string, :alias => '-s'

    def download(table_name, category, destination='.')
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
        fec_tables = fec_tables[table_name.downcase].select do |table|
          table['category'] == category.downcase
        end
      else
        fec_tables = fec_tables[table_name.downcase]
      end


      if options['format'] == 'db'
        # TODO
        # initialize_db_tables(table_name, fec_tables)
      end

      raise Fech::InvalidTable, "#{category} of #{table_name}" if fec_tables.empty?
      process_request(fec_tables, destination, options)
    end

    desc 'show help menu', 'help information'
    def help

      msg =
        """
          Primary Tables (the first argument) and their available categories

                  candidates (contribution, summary, detail, current)
                  individuals (summary)
                  committees (summary, link, detail)

          To use, use the following in your prompt:

            $ fech-ftp download <PRIMARY_TABLE> <CATEGORY> --year=<ELECTION YEAR (YYYY format)> --format=<FILE FORMAT (csv is the only format supported)>



           (you can also specify the file destination by entering it in after CATEGORY - it defaults to current directory)
          example:

            for records involving candidates and their contributions in 2012, exported into a CSV file:

              $ fech-ftp candidates contribution --year=2012 --format=csv

            for a summary of committees in 2008, exported into plain ruby Struct objects:

              $ fech-ftp committees summary --year=2008

            (if you want to grab everything from a primary table, replace the field for category with `all`)

            Eventually I will add support for making it easier to import into a database, and to view the database
            locally on a server.

        """
      puts msg
    end

    desc 'runs server', 'starts a sinatra server on http://localhost:9393'
    def server
      # TODO
      Fech::Server.start!
    end
  end
end
