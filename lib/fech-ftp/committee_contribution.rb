module Fech
  class CommitteeContribution < FechFTP

    def initialize(cycle)
      @cycle   = cycle
      @file    = "oth#{cycle.to_s[2..3]}.zip"
      @records = []
    end

    # corresponds to the itoth file described here:
    # http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCommitteetoCommittee.shtml

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
