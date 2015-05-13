module Fech
  class FileHandler
    def initialize(year, opts={})
      @year        = year
      @format      = opts[:format]
      @destination = opts[:destination]
      @keep_source = opts[:source]
      @output      = []
      @input       = []
    end

    def parse_date(date)
      if date == '' && table_exist?
        if table_exist?
          return Date.new(@year, 1,1)
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

    # log into the FEC FTP server and download relevant file

    def fetch_file
      zip_file = "#{@file}#{@year.to_s[2..3]}.zip"
      Net::FTP.open("ftp.fec.gov") do |ftp|
        ftp.login
        ftp.chdir("./FEC/#{@year}")
        begin
          ftp.get(zip_file, "./#{zip_file}")
        rescue Net::FTPPermError
          raise 'File not found - please try the other methods'
        end
      end

      unzip(zip_file)
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

    def keep_source_file?
      @source_file
    end

    # unzip, delete the compressed file
    # yield file content(s) to_enum, map with headers.

    def unzip(zip_file)
      Zip::File.open(zip_file) do |zip|
        zip.each do |entry|
          @file = entry.extract("#{@dest}/#{entry.name}") if !File.file?(entry.name)
        end
      end

      return @file
    end
  end
end
