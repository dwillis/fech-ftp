module Fech
  class Table
    AWS_URL = "https://cg-519a459a-0ea3-42c2-b7bc-fa1143481f74.s3-us-gov-west-1.amazonaws.com/bulk-downloads"

    def initialize(cycle, opts={})
      @cycle    = cycle
      @headers  = opts[:headers]
      @file     = opts[:file]
      @format   = opts[:format]
      @location = opts[:location]
      @passive  = opts[:passive]
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
        table_exist? ? @receiver << row : create_table(row)
      when :csv
        @receiver << row.values
      else
        @receiver << row
      end
    end

    # the @receiver obj is the database itself.
    # This assumes the table needs to be created.

    def table_exist?
      @receiver.respond_to? :columns
    end

    def create_table(row)
      db, table = @receiver
      table = table.to_s.pluralize.to_sym
      db.create_table(table) { primary_key :id }

      row.each do |k,v|
        v = v.nil? ? String : v.class
        db.alter_table table do
          add_column k, v
        end
      end

      @receiver = db[table]
      @receiver << row
    end

    def fetch_file(&blk)
      filename = "#{@file}#{@cycle.to_s[2..3]}.zip"
      uri = URI("#{AWS_URL}/#{@cycle}/#{filename}")
      response = Net::HTTP.get_response(uri)

      if response.code == '200'
        unzip(response.body, &blk)
      end
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
      if date == '' && table_exist?
        if table_exist?
          return Date.new(@cycle, 1,1)
        else
          return ''
        end
      end

      if date.length == 8
        Date.strptime(date, "%m%d%Y")
      else
        Date.parse(date)
      end
    end

    def unzip(zip_file, &blk)
      Zip::File.open_buffer(zip_file) do |zip|
        zip.each do |entry|
          path = @location.nil? ? entry.name : @location + entry.name
          entry.extract(path) if !File.file?(path)

          File.foreach(path) do |row|
            blk.call(format_row(row))
          end
        end
      end
    end
  end
end
