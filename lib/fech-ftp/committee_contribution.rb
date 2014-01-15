module Fech
  class CommitteeContribution

  	# corresponds to the itoth file described here:
  	# http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCommitteetoCommittee.shtml

    def self.load(cycle)
      cols = [:committee_id, :amendment, :report_type, :primary_general, :microfilm, :transaction_type, :entity_type, :name, :city, :state, :zipcode, 
      	:employer, :occupation, :date, :amount, :other_committee_id, :transaction_id, :filing_id, :memo_code, :memo_text, :fec_record_number]
      url = "ftp://ftp.fec.gov/FEC/#{cycle}/oth#{cycle.to_s[2..3]}.zip"
      t = RemoteTable.new url, :filename => "itoth.txt", :col_sep => "|", :headers => cols
      rows = t.entries
      rows.each do |row|
        row.merge!({
          committee_id: row[:committee_id], 
          amendment: row[:amendment],
          report_type: row[:report_type], 
          primary_general: row[:primary_general],
          microfilm: row[:microfilm],
          transaction_type: row[:transaction_type],
          entity_type: row[:entity_type],
          name: row[:name],
          city: row[:city], 
          state: row[:state],
          zipcode: row[:zipcode],
          employer: row[:employer],
          occupation: row[:occupation],
          date: begin Date.parse(row[:date]) rescue row[:date] end,
          amount: row[:amount].to_f,
          other_committee_id: row[:other_committee_id], 
          transaction_id: row[:transaction_id],
          filing_id: row[:filing_id].to_i,
          memo_code: row[:memo_code],
          memo_text: row[:memo_text],
          fec_record_number: row[:fec_record_number]
         })
      end
      rows
    end
  end
end
