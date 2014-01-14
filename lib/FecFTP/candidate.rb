module FecFTP
  class Candidate

    # corresponds to the FEC Candidate master file described here:
    # http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCandidateMaster.shtml
    def self.detail(cycle)
      cols = [:candidate_id, :candidate_name, :party, :election_year, :office_state, :office, :district, :status, :committee_id, :street_one, :street_two, :city, :state, :zipcode]
      url = "ftp://ftp.fec.gov/FEC/#{cycle}/cn#{cycle.to_s[2..3]}.zip"
      t = RemoteTable.new url, :filename => "cn.txt", :col_sep => "|", :headers => cols
      t.entries
    end
    
    # summary financial information for current candidates in a cycle.
    # http://www.fec.gov/finance/disclosure/metadata/DataDictionaryWEBL.shtml
    def self.current_summary(cycle)
      cols = [:candidate_id, :candidate_name, :status, :party_code, :party, :total_receipts, :transfers_from_authorized, :total_disbursements, :transfers_to_authorized, :beginning_cash, 
        :ending_cash, :candidate_contributions, :candidate_loans, :other_loans, :candidate_loan_repayments, :other_loan_repayments, :debts_owed_by, :total_individual_contributions, 
        :office_state, :district, :special_election_status, :primary_election_status, :runoff_election_status, :general_election_status, :general_election_percent, :pac_contributions, 
        :party_contributions, :coverage_end_date, :individual_refunds, :committee_refunds]
      url = "ftp://ftp.fec.gov/FEC/#{cycle}/webl#{cycle.to_s[2..3]}.zip"
      t = RemoteTable.new url, :filename => "webl#{cycle.to_s[2..3]}.txt", :col_sep => "|", :headers => cols
      t.entries
    end
    
    # summary financial information for all candidates in a cycle.
    # http://www.fec.gov/finance/disclosure/metadata/DataDictionaryWEBALL.shtml
    def self.all_summary(cycle)
      cols = [:candidate_id, :candidate_name, :status, :party_code, :party, :total_receipts, :transfers_from_authorized, :total_disbursements, :transfers_to_authorized, :beginning_cash, 
        :ending_cash, :candidate_contributions, :candidate_loans, :other_loans, :candidate_loan_repayments, :other_loan_repayments, :debts_owed_by, :total_individual_contributions, 
        :office_state, :district, :special_election_status, :primary_election_status, :runoff_election_status, :general_election_status, :general_election_percent, :pac_contributions, 
        :party_contributions, :coverage_end_date, :individual_refunds, :committee_refunds]
      url = "ftp://ftp.fec.gov/FEC/#{cycle}/weball#{cycle.to_s[2..3]}.zip"
      t = RemoteTable.new url, :filename => "weball#{cycle.to_s[2..3]}.txt", :col_sep => "|", :headers => cols
      t.entries
    end

  end
end
