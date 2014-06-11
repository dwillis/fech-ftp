module Fech
  class FechFTP

    def fetch_file(cycle, file, &blk)
      ftp = Net::FTP.new("ftp.fec.gov")
      ftp.login
      ftp.chdir("./FEC/#{cycle}")
      ftp.get(file, "./#{file}")
      unzip(file, &blk)
    end

    def float_fields
      %w{cash amount contributions total loan trans debts refund expenditure}
    end

    def format_row(line, headers)
      hash = {}
      line = line.chomp.split("|")

      headers.each_with_index do |k,i|
        if k.to_s =~ /cash|amount|contributions|total|loan|transfer|debts|refund|expenditure/
          hash[k] = line[i].to_f
        elsif k == :filing_id
          hash[k] = line[i].to_i
        elsif k.to_s =~ /_date/
          hash[k] =
            begin
              Date.parse(line[i])
            rescue
              line[i]
            end
        else
          hash[k] = line[i]
        end
      end

      hash
    end

    def unzip(file, &blk)
      Zip::File.open(file) do |zip|
        zip.each do |entry|
          entry.extract("./#{entry.name}")
          File.delete(file)
          File.foreach(entry.name, encoding: 'UTF-8', invalid: :replace, replace: ' ') do |row|
            blk.call(row, entry.name)
          end
          File.delete(entry.name)
        end
      end
    end
  end
end