module FecFTP
  class CommitteeContribution

  	# corresponds to the itoth file described here:
  	# http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCommitteetoCommittee.shtml

    def self.load(cycle)
      cols = [:committee_id, :amendment, :report_type, :primary_general, :microfilm, :transaction_type, :entity_type, :name, :city, :state, :zipcode, 
      	:employer, :occupation, :date, :amount, :other_committee_id, :candidate_id, :transaction_id, :filing_id, :memo_code, :memo_text, :fec_record_number]
      url = "ftp://ftp.fec.gov/FEC/#{cycle}/oth#{cycle.to_s[2..3]}.zip"
      t = RemoteTable.new url, :filename => "itoth.txt", :col_sep => "|", :headers => cols
      t.entries
    end

    
    


  end
end
