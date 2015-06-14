module Fech
  class Table
    attr_reader :lines, :headers, :table, :category
    def initialize(destination, properties={})
      @destination   = destination
      @table         = properties['table']
      @fec_file      = properties['fec_file']
      @headers       = properties['headers']
      @category      = properties['category']
      @year          = properties['year']
      @export_format = properties['format']
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

    def fetch_zip_file
      Net::FTP.open(FTP_SETTINGS['url']) do |ftp|
        begin
          ftp.login
          file_size = ftp.size(ftp_path).fdiv(1_000_000).round(1)
          puts "File size for #{table} is #{file_size} MB's. This may take a while..."
          ftp.get(ftp_path, ftp_destination)
        rescue Net::FTPPermError
          raise 'connection failure'
        end
      end
    end

    def output_endpoint
      @output_endpoint ||= if @format == 'csv'
        CSV.open("#{export_filename}.csv", 'w+', headers: headers, write_headers: true)
      elsif @format == 'db'
        # ???
      else
        []
      end
    end

    def download_table_data
      fetch_zip_file if !File.exist?(ftp_destination)
      Zip::File.open(ftp_destination) do |zip|
        # parse(zip.first.get_input_stream)
        file = zip.first
        stream = file.get_input_stream
        # prct = Array.new(100) { |i| (chunk_size * i) + chunk_size }
        progress_bar = Array.new(50)
        records = 0
        until stream.eof? # '[###########-------] 20% complete'
          records += 1
          progress = 100 - ((file.size - stream.pos).fdiv(file.size) * 100).round(1)
          progress_bar.map!.with_index { |x,i| i > (progress / 2) ? '-' : '#' }.reverse
          $stdout.flush

          line = stream.gets.split("|")
          line[-1].chomp!
          output_endpoint << struct.new(*line).format!
          print "  Converting.... [ #{progress_bar.join} ] #{progress.round(1)}% complete, #{records} records so far \r"
        end

        output_endpoint.close if output_endpoint.is_a?(CSV)
      end

      File.delete(ftp_destination)
    end
  end
end
