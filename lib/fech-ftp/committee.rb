module Fech
  class Committee < FechFTP

    def initialize(cycle, opts={})
      @cycle   = cycle
      @type    = opts[:type]
      @mode    = opts[:mode]
      @records = []
    end

    def table(receiver=nil)
      file = HEADERS[@type][:file] + "#{@cycle.to_s[2..3]}.zip"
      headers = HEADERS[@type][:headers]

      fetch_file(@cycle, file) do |row, fi|
        entry = format_row(row, headers)

        if @mode
          receiver << entry
        else
          @records << format_row(entry, headers)
        end
      end

      if receiver
        receiver.close
      else
        @records
      end
    end

    def self.load_superpacs
      url = "http://www.fec.gov/press/press2011/ieoc_alpha.shtml"
      t = RemoteTable.new url, :row_xpath => '//table/tr', :column_xpath => 'td', :encoding => 'windows-1252', :headers => %w{ row_id committee_id committee_name filing_frequency}
      t.entries
    end
  end
end
