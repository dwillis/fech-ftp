module Fech
  class Table
    def initialize(cycle, opts={})
      @cycle    = cycle
      @headers  = opts[:headers]
      @file     = opts[:file]
      @format   = opts[:format]
      @receiver = opts[:connection] || receiver
      @parser   = parser
    end

    def receiver
      if @format == :csv
        CSV.open("#{@file}#{@cycle.to_s[2..3]}.csv", 'a+', headers: @headers, write_headers: true)
      else
        []
      end
    end

    def retrieve_data
      fetch_file { |row| enter_row(row) }
      return @receiver
    end

    def enter_row(row)
      case @format
      when :db
        db_empty? ? create_columns(row) : @receiver << row
      when :csv
        @receiver << row.values
      else
        @receiver << row
      end
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
      zip_file = "#{@file}#{@cycle.to_s[2..3]}.zip"
      Net::FTP.open("ftp.fec.gov") do |ftp|
        ftp.login
        ftp.chdir("./FEC/#{@cycle}")
        begin
          ftp.get(zip_file, "./#{zip_file}")
        rescue Net::FTPPermError
          raise 'File not found - please try the other methods'
        end
      end

      unzip(zip_file, &blk)
    end

    def parser
      @headers.map.with_index do |h,i|
        if h.to_s =~ /cash|amount|contributions|total|loan|transfer|debts|refund|expenditure/
          [h, ->(line) { line[i].to_f }]
        elsif h == :filing_id
          [h, ->(line) { line[i].to_i }]
        elsif h.to_s =~ /_date/
          [h, ->(line) { parse_date(line[i]) }]
        else
          [h, ->(line) { line[i] }]
        end
      end
    end

    def format_row(line)
      hash = {}
      line = line.encode('UTF-8', invalid: :replace, replace: ' ').chomp.split("|")

      @parser.each { |k,blk| hash[k] = blk.call(line) }

      return hash
    end

    def parse_date(date)
      if date.length == 8
        Date.strptime(date, "%m%d%Y")
      else
        Date.parse(date)
      end
    end

    def unzip(zip_file, &blk)
      Zip::File.open(zip_file) do |zip|
        zip.each do |entry|
          entry.extract("./#{entry.name}") if !File.file?(entry.name)
          File.delete(zip_file)
          File.foreach(entry.name) do |row|
            blk.call(format_row(row))
          end
          File.delete(entry.name)
        end
      end
    end
  end
end