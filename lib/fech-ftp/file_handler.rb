module Fech
  class FileHandler
    def initialize(year, opts={})
      @year        = year
      @format      = opts[:format]
      @destination = opts[:destination]
      @keep_source = opts[:source]
      @output      = []
    end

    def <<(record)
      case @format.to_sym
      when :csv then @output << record.values
      when :db  then @output << stuff
      else
        @output << record
      end
    end

    # log into the FEC FTP server and download relevant file

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

    def retrieve_data
      fetch_file { |row| enter_row(row) }
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

    def unzip(zip_file, &blk)
      Zip::File.open(zip_file) do |zip|
        zip.each do |entry|
          entry.extract("#{@dest}/#{entry.name}") if !File.file?(entry.name)
          File.delete(zip_file)
          File.foreach(entry.name) do |row|
            yield row
          end
          File.delete(entry.name)
        end
      end
    end
  end
end
