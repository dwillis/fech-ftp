module Fech
  class Table
    attr_reader :subtable
    def initialize(table_name, properties={})
      @table       = FTP_SETTINGS['tables'][table_name.downcase]
      @col_types   = FTP_SETTINGS['tables']['col_types']
      @destination = properties['destination']
      @subtable    = properties['subtable']
      @year        = properties['year']
      @format      = properties['format']
      @lines       = []
    end

    def table_attrs
      @table_attrs ||= @table[subtable]
    end

    # change to table_name from table
    def struct
      @struct ||= Struct.new(table_attrs['table'], *table_attrs['headers']) do
        def parse_date(date)
          if date.empty?
            nil
          elsif date.length == 8
              Date.strptime(date, "%m%d%Y")
          else
            Date.parse(date)
          end
        end

        def format!
          types = FTP_SETTINGS['tables']['col_types']
          members.each do |header|
            if Regexp.new(types['float']) =~ header
              self[header] = self[header].to_f
            elsif Regexp.new(types['date']) =~ header
              self[header] = parse_date(self[header])
            elsif Regexp.new(types['integer']) =~ header
              self[header] = self[header].to_i
            end
          end

          return self
        end
      end
    end

    def export
      case @format
      when 'csv' then to_csv
      when 'db'  then to_db
      else
        @lines
      end
    end

    def to_db
      # to do
    end

    def to_csv
      CSV.open(export_filename, 'w+', headers: table_attrs['headers'], write_headers: true) do |csv|
        @lines.each { |line| csv << line.values }
      end
    end

    def filename
      @filename ||= table_attrs['filename'] + @year.to_s[2..3]
    end

    def ftp_destination
      "#{@destination}/#{filename}.zip"
    end

    def txt_file
      "#{@destination}/#{filename}.txt"
    end

    def ftp_path
      "./FEC/#{@year}/#{filename}.zip"
    end

    def export_filename
      "#{@destination}/#{@table.capitalize}#{subtable.capitalize}_#{year}"
    end

    def <<(stream)
      stream.readlines.each do |ln|
        line = ln.split("|")
        line[-1].chomp!
        @lines << struct.new(*line).format!
      end
    end

    def exist?
      @table.is_a?(Hash) && @table[@subtable].is_a?(Hash)
    end
  end
end
