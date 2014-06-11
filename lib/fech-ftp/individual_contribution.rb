module Fech
  class IndividualContribution < FechFTP

    def initialize(cycle, opts={})
      @cycle   = cycle
      @file    = "indiv#{cycle.to_s[2..3]}.zip"
      @mode    = opts[:mode]
      @records = []
    end

    def table(receiver=nil)
      fetch_file(@cycle, @file) do |row, filename|
        entry = format_row(row, HEADERS)

        if @mode
          receiver << entry
        else
          @records << format_row(entry, HEADERS)
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