module Fech
  class Candidate < FechFTP

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
          @records << entry
        end
      end

      if receiver
        receiver.close
      else
        @records
      end
    end
  end
end

