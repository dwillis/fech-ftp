module Fech
  module FileHandler
    # log into the FEC FTP server and download relevant file

    def parse_date(date)
      return Date.new(1, 1, @year) if date.empty?
      date.length == 8 ? Date.strptime(date, "%m%d%Y") : Date.parse(date)
    end

    def zip_file
      "#{@properties[:file]}#{@properties[:year].to_s[2..3]}.zip"
    end

    def file_downloaded?
      File.exist? "#{@destination}/#{zip_file}"
    end

    def txt_file
      "#{@properties[:file]}.txt"
    end

    # unzip, delete the compressed file
    # yield file content(s) to_enum, map with headers.

    def extract
      Zip::File.open(zip_file) do |zip|
        zip.extract txt_file, "#{@destination}/#{txt_file}"
      end

      return File.readlines "#{@destination}/#{txt_file}"
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
  end
end
