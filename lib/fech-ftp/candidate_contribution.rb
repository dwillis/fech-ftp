module Fech
  class CandidateContribution < FechFTP

    def initialize(cycle, opts={})
      @cycle   = cycle
      @file    = "pas2#{cycle.to_s[2..3]}.zip"
      @mode    = opts[:mode]
      @records = []
    end

    def table(receiver=nil)
      fetch_file(@cycle, @file) do |row|
        entry = format_row(row, HEADERS)

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
