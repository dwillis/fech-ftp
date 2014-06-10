module Fech
  class Committee < FechFTP

    def initialize(cycle, type)
      @cycle   = cycle
      @type    = type
      @records = []
    end

    def fetch
      file = HEADERS[@type][:file] + "#{@cycle.to_s[2..3]}.zip"
      headers = HEADERS[@type][:headers]

      fetch_file(@cycle, file) do |data|
        data.each { |row| @records << format_row(row, headers) }
      end

      @records
    end

    def self.load_superpacs
      url = "http://www.fec.gov/press/press2011/ieoc_alpha.shtml"
      t = RemoteTable.new url, :row_xpath => '//table/tr', :column_xpath => 'td', :encoding => 'windows-1252', :headers => %w{ row_id committee_id committee_name filing_frequency}
      t.entries
    end
  end
end
