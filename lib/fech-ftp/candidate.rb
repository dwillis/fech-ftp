require 'benchmark'
require 'remote_table'
module Fech
  class Candidate < FechFTP

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
  end
end

