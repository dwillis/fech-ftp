module FecFTP
  class Committee

    # corresponds to the FEC Committee master file described here:
    # http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCommitteeMaster.shtml

    def self.detail(cycle)
      cols = [:committee_id, :committee_name, :treasurer, :street_one, :street_two, :city, :state, :zipcode, :designation, :type, :party, :filing_frequency, :category, :connected_organization, :candidate_id]
      url = "ftp://ftp.fec.gov/FEC/#{cycle}/cm#{cycle.to_s[2..3]}.zip"
      t = RemoteTable.new url, :filename => "cm.txt", :col_sep => "|", :headers => cols
      t.entries
    end
    
    def self.pac_summary(cycle)
      cols = [:committee_id, :committee_name, :type, :designation, :filing_frequency, :total_receipts, :transfers_from_affiliates, :individual_contributions, :pac_contributions, :candidate_contributions, 
        :candidate_loans, :total_loans_received, :total_disbursements, :transfers_to_affiliates, :individual_refunds, :committee_refunds, :candidate_loan_repayments, :loan_repayments, :beginning_year_cash, 
        :ending_cash, :debts_owed_by, :nonfederal_transfers_received, :contributions_to_committees, :independent_expenditures, :party_coordinated_expenditures, :nonfederal_share_expenditures, :coverage_end_date]
      url = "ftp://ftp.fec.gov/FEC/#{cycle}/webk#{cycle.to_s[2..3]}.zip"
      t = RemoteTable.new url, :filename => "webk#{cycle.to_s[2..3]}.txt", :col_sep => "|", :headers => cols
      t.entries
    end

  end
end
