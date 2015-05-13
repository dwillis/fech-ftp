module Fech
  class Table
    def initialize(election_year, opts={})
      @election = election_year
      @headers  = opts[:headers]
      @receiver = Dispatcher.new(opts)
    end

    def parse!
      zip_file = @receiver.fetch_file
    end

    def convert
      @receiver.formatted_lines.map { |x| parse_line(x) }
    end

    def parse_line(line, record={})
      @headers.each_with_index do |k,i|
        if h.to_s =~ /cash|amount|contributions|total|loan|transfer|debts|refund|expenditure/
          record[k] = line[i].to_f
        elsif h == :filing_id
          record[k] = line[i].to_i
        elsif h.to_s =~ /_date/
          record[k] = @receiver.parse_date line[i]
        else
          record[k] = line[i]
        end
      end

      return record
    end
  end
end
