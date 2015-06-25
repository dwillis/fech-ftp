module Fech
  class Table

    attr_reader :lines, :headers, :table, :category, :export_format
    def initialize(destination, properties={})
      @destination   = destination
      @table         = properties['table']
      @fec_file      = properties['fec_file']
      @headers       = properties['headers']
      @category      = properties['category']
      @receiver      = properties['format']
      @year          = properties['year']
      @bar           = '-' * 50
      @rows          = []
    end

    def struct
      @struct ||= Struct.new(table, *headers) do
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
          types = FTP_SETTINGS[:col_types]
          members.each do |header|
            if Regexp.new(types[:float]) =~ header
              self[header] = self[header].to_f
            elsif Regexp.new(types[:date]) =~ header
              self[header] = parse_date(self[header])
            elsif Regexp.new(types[:integer]) =~ header
              self[header] = self[header].to_i
            end
          end

          return self
        end
      end
    end

    def filename
      "#{@fec_file}#{@year.to_s[2..3]}"
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
      "#{@destination}/#{table}_#{@year}"
    end

    def zip_downloaded?
      File.file?(ftp_destination)
    end

    def download_table_data
      Net::FTP.open(FTP_SETTINGS['url']) do |ftp|
        begin
          ftp.login
          compressed_size = ftp.size(ftp_path).fdiv(1_000_000).round(1)
          print "Zip file size for #{table} is #{compressed_size} MB's. This may take a while...\n" if compressed_size > 40.0
          $stdout.flush
          ftp.get(ftp_path, ftp_destination)
        rescue Net::FTPPermError
          raise 'connection failure'
        end
      end
    end

    def create_record(stream, total, saved = 0)
      $stdout.flush
      percent = saved.fdiv(total)
      index = (percent * 50).to_i
      @bar[index] = '#' if @bar[index] == '-'
      print progress(percent, total, saved)
      line = stream.gets.split('|')
      line[-1].chomp!

      return struct.new(*line).format!
    end

    def to_csv(stream, total, saved = 0)
      CSV.open("#{export_filename}.csv", 'w+', headers: headers, write_headers: true) do |csv|
        csv << create_record(stream, total, saved += 1) until stream.eof?
      end
    end

    def progress(percent, total, saved)
      "  [ #{@bar} ] #{(percent * 100).round(1)}% complete - processing #{saved}/#{total} records\r"
    end

    def setup_db_columns(stream)
      record = create_record(stream, total)
      record.each do |k,v|
        DB.add_column(@table, )
      end
    end

    def decompress
      Zip::File.open(ftp_destination) do |zip|
        total_records = zip.first.get_input_stream.count
        stream = zip.first.get_input_stream

        if @receiver == 'csv'
          to_csv(stream, total_records)
        elsif @receiver == 'db'
          setup_db_columns(stream)
          DB[@table.to_sym] << create_record(stream, total_records, 1)
        else
          @rows << create_record(stream, total_records)
        end
      end

      File.delete(ftp_destination)
    end
  end
end
