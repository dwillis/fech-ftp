module Fech
  class CommitteeContribution < FechFTP

    def initialize(cycle)
      @cycle         = cycle
      @file          = "oth#{cycle.to_s[2..3]}.zip"
      @contributions = []
      @headers       = [
        :committee_id, :amendment, :report_type, :primary_general, :microfilm,
        :transaction_type, :entity_type, :name, :city, :state, :zipcode,
        :employer, :occupation, :date, :amount, :other_committee_id,
        :transaction_id, :filing_id, :memo_code, :memo_text, :fec_record_number
      ]
    end

    # corresponds to the itoth file described here:
    # http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCommitteetoCommittee.shtml

    def fetch
      fetch_file(@cycle, @file) do |data|
        data.each { |row| @contributions << format_row(row, @headers) }
      end

      @contributions
    end
  end
end
