module Fech
  class Table

    def initialize(opts={})
      @remote   = opts[:remote]
      @file     = opts[:file]
      @headers  = opts[:headers]
      @mode     = opts[:mode]
      @cycle    = opts[:cycle]
      @type     = opts[:type]
      @receiver = opts[:receiver] || []
    end

    def retrieve_data
      if super_pacs?
        @remote.each { |row| enter_row(row) }
      else
        fetch_file { |row| enter_row(row) }
      end

      @receiver if @receiver.is_a?(Array)
    end

    def enter_row(row)
      case @mode
      when :to_db
        db_empty? ? create_columns(row) : @receiver << row
      when :to_csv
        @receiver << row.values
      else
        @receiver << row
      end
    end

    def super_pacs?
      @remote
    end

    def db_empty?
      @receiver.columns.length <= 1
    end

    def create_columns(row)
      # this assumes the Sequel::Dataset provided already contains the
      # primary_key as :id and nothing else. Still figuring out a way
      # to automatically create a table if only the DB constant is provided,
      # and have the primary_key be set as the #{table}_id column name.
      # From there, it will be easier to tie in foreign keys.
      table = @receiver.first_source
      row.each do |k,v|
        DB.alter_table table do
          add_column k, v.class
        end
      end
      @receiver << row
    end

    def fetch_file(&blk)
      Net::FTP.open("ftp.fec.gov") do |ftp|
        ftp.login
        ftp.chdir("./FEC/#{@cycle}")
        ftp.get(@file, "./#{@file}")
      end

      unzip(&blk)
    end

    def format_row(line)
      hash = {}
      line = line.encode('UTF-8', invalid: :replace, replace: ' ').chomp.split("|")

      @headers.each_with_index do |k,i|
        if k.to_s =~ /cash|amount|contributions|total|loan|transfer|debts|refund|expenditure/
          hash[k] = line[i].to_f
        elsif k == :filing_id
          hash[k] = line[i].to_i
        elsif k.to_s =~ /_date/
          hash[k] =
            begin
              parse_date(line[i])
            rescue ArgumentError
              line[i]
            end
        else
          hash[k] = line[i]
        end
      end

      hash
    end

    def parse_date(date)
      if date.length == 8
        Date.strptime(date, "%m%d%Y")
      else
        Date.parse(date)
      end
    end

    def unzip(&blk)
      Zip::File.open(@file) do |zip|
        zip.each do |entry|
          entry.extract("./#{entry.name}") if !File.file?(entry.name)
          File.delete(@file)
          File.foreach(entry.name) do |row|
            blk.call(format_row(row))
          end
          File.delete(entry.name)
        end
      end
    end
  end
end