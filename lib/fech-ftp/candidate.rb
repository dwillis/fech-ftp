module Fech
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
      rows = t.entries
      rows.each do |row|
        row.merge!({
          candidate_id: row[:candidate_id], 
          candidate_name: row[:candidate_name],
          status: row[:status], 
          party_code: row[:party_code],
          party: row[:party],
          total_receipts: row[:total_receipts].to_f,
          transfers_from_authorized: row[:transfers_from_authorized].to_f,
          total_disbursements: row[:total_disbursements].to_f,
          transfers_to_authorized: row[:transfers_to_authorized].to_f, 
          beginning_cash: row[:beginning_cash].to_f,
          ending_cash: row[:ending_cash].to_f,
          candidate_contributions: row[:candidate_contributions].to_f,
          candidate_loans: row[:candidate_loans].to_f,
          other_loans: row[:other_loans].to_f,
          candidate_loan_repayments: row[:candidate_loan_repayments].to_f, 
          other_loan_repayments: row[:other_loan_repayments].to_f, 
          debts_owed_by: row[:debts_owed_by].to_f,
          total_individual_contributions: row[:total_individual_contributions].to_f,
          office_state: row[:office_state], 
          district: row[:district],
          special_election_status: row[:special_election_status],
          primary_election_status: row[:primary_election_status],
          runoff_election_status: row[:runoff_election_status],
          general_election_status: row[:general_election_status], 
          general_election_percent: row[:general_election_percent].to_f,
          pac_contributions: row[:pac_contributions].to_f,
          party_contributions: row[:party_contributions].to_f, 
          coverage_end_date: begin Date.parse(row[:coverage_end_date]) rescue row[:coverage_end_date] end,
          individual_refunds: row[:individual_refunds].to_f,
          committee_refunds: row[:committee_refunds].to_f
          })
      end
      rows
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
      rows = t.entries
      rows.each do |row|
        row.merge!({
          candidate_id: row[:candidate_id], 
          candidate_name: row[:candidate_name],
          status: row[:status], 
          party_code: row[:party_code],
          party: row[:party],
          total_receipts: row[:total_receipts].to_f,
          transfers_from_authorized: row[:transfers_from_authorized].to_f,
          total_disbursements: row[:total_disbursements].to_f,
          transfers_to_authorized: row[:transfers_to_authorized].to_f, 
          beginning_cash: row[:beginning_cash].to_f,
          ending_cash: row[:ending_cash].to_f,
          candidate_contributions: row[:candidate_contributions].to_f,
          candidate_loans: row[:candidate_loans].to_f,
          other_loans: row[:other_loans].to_f,
          candidate_loan_repayments: row[:candidate_loan_repayments].to_f, 
          other_loan_repayments: row[:other_loan_repayments].to_f, 
          debts_owed_by: row[:debts_owed_by].to_f,
          total_individual_contributions: row[:total_individual_contributions].to_f,
          office_state: row[:office_state], 
          district: row[:district],
          special_election_status: row[:special_election_status],
          primary_election_status: row[:primary_election_status],
          runoff_election_status: row[:runoff_election_status],
          general_election_status: row[:general_election_status], 
          general_election_percent: row[:general_election_percent].to_f,
          pac_contributions: row[:pac_contributions].to_f,
          party_contributions: row[:party_contributions].to_f, 
          coverage_end_date: begin Date.parse(row[:coverage_end_date]) rescue row[:coverage_end_date] end,
          individual_refunds: row[:individual_refunds].to_f,
          committee_refunds: row[:committee_refunds].to_f
          })
      end
      rows
    end

  end
end
