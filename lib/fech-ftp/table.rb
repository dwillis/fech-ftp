module Fech
  class Table
    include Fech::FileHandler

    def initialize(opts={})
      @destination = opts[:destination]
      @year        = opts[:year]
      @properties  = opts[:properties]
    end

    def download
      Net::FTP.open("ftp.fec.gov") do |ftp|
        ftp.login
        begin
          ftp.get(zip_file, "./#{zip_file}")
        rescue Net::FTPPermError
          false
        end
      end
    end

    private

    def table_rows
      @table_rows ||= extract.inject({}) do |dict, values|
        procs.each_with_index do |p,index|
          dict[headers[index]] = p.call values[index]
        end

        dict
      end
    end

    def headers
      @properties[:headers]
    end

    def procs
      @procs ||= headers.map do |header|
        if header.to_s =~ /cash|amount|contributions|total|loan|transfer|debts|refund|expenditure/
          ->(item) { item.to_f }
        elsif header == :filing_id
          ->(item) { item.to_i }
        elsif header.to_s =~ /_date/
          ->(item) { parse_date(item) }
        end
      end
    end
  end
end
