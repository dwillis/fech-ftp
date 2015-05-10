module Fech
  class Table
    def initialize(election_year, opts={})
      @election = election_year
      @headers  = opts[:headers]
      @receiver = Dispatcher.new(opts)
    end

    # def enter_row(row)
    #   case @format
    #   when :db
    #     table_exist? ? @receiver << row : create_table(row)
    #   when :csv
    #     @receiver << row.values
    #   else
    #     @receiver << row
    #   end
    # end

    def parser
      @parser ||= @headers.map.with_index do |h,i|
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

    def format_row(line, record={})
      line = line.encode('UTF-8', invalid: :replace, replace: ' ').chomp.split("|")
      parser.each_with_index do |(k,blk),i|
        record[k] = blk.call(line) if line[i]
      end

      @receiver << record
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
  end
end
