module Fech
  class Committee

    DETAIL_COLS = [:committee_id, :committee_name, :treasurer, :street_one, :street_two, :city, :state, :zipcode, :designation, :type, :party, :filing_frequency, :category, :connected_organization, :candidate_id]
    SUMMARY_COLS = [:committee_id, :committee_name, :type, :designation, :filing_frequency, :total_receipts, :transfers_from_affiliates, :individual_contributions, :pac_contributions, :candidate_contributions, 
        :candidate_loans, :total_loans_received, :total_disbursements, :transfers_to_affiliates, :individual_refunds, :committee_refunds, :candidate_loan_repayments, :loan_repayments, :beginning_year_cash, 
        :ending_cash, :debts_owed_by, :nonfederal_transfers_received, :contributions_to_committees, :independent_expenditures, :party_coordinated_expenditures, :nonfederal_share_expenditures, :coverage_end_date]

    def self.write_to_csv(method, cycle)
      headers = method == 'detail' ? DETAIL_COLS : SUMMARY_COLS
      rows = self.send(method, cycle)
      Fech::Utilities.write_to_csv("committees_#{method}_#{cycle}", headers, rows)
    end

    # corresponds to the FEC Committee master file described here:
    # http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCommitteeMaster.shtml
    def self.detail(cycle)
      url = "ftp://ftp.fec.gov/FEC/#{cycle}/cm#{cycle.to_s[2..3]}.zip"
      t = RemoteTable.new url, :filename => "cm.txt", :col_sep => "|", :headers => DETAIL_COLS
      t.entries
    end
    
    # http://www.fec.gov/finance/disclosure/metadata/DataDictionaryWEBK.shtml
    def self.summary(cycle)
      url = "ftp://ftp.fec.gov/FEC/#{cycle}/webk#{cycle.to_s[2..3]}.zip"
      t = RemoteTable.new url, :filename => "webk#{cycle.to_s[2..3]}.txt", :col_sep => "|", :headers => SUMMARY_COLS
      rows = t.entries
      rows.each do |row|
        row.merge!({
          committee_id: row[:committee_id], 
          committee_name: row[:committee_name],
          type: row[:type], 
          designation: row[:designation],
          filing_frequency: row[:filing_frequency],
          total_receipts: row[:total_receipts].to_f,
          transfers_from_affiliates: row[:transfers_from_affiliates].to_f,
          individual_contributions: row[:individual_contributions].to_f,
          pac_contributions: row[:pac_contributions].to_f, 
          candidate_contributions: row[:candidate_contributions].to_f,
          candidate_loans: row[:candidate_loans].to_f,
          total_loans_received: row[:total_loans_received].to_f,
          total_disbursements: row[:total_disbursements].to_f,
          transfers_to_affiliates: row[:transfers_to_affiliates].to_f,
          individual_refunds: row[:individual_refunds].to_f, 
          committee_refunds: row[:committee_refunds].to_f, 
          candidate_loan_repayments: row[:candidate_loan_repayments].to_f,
          loan_repayments: row[:loan_repayments].to_f,
          beginning_year_cash: row[:beginning_year_cash].to_f,
          ending_cash: row[:ending_cash].to_f,
          debts_owed_by: row[:debts_owed_by].to_f,
          nonfederal_transfers_received: row[:nonfederal_transfers_received].to_f, 
          contributions_to_committees: row[:contributions_to_committees].to_f,
          independent_expenditures: row[:independent_expenditures].to_f,
          party_coordinated_expenditures: row[:party_coordinated_expenditures].to_f,
          nonfederal_share_expenditures: row[:nonfederal_share_expenditures].to_f,
          coverage_end_date: begin Date.parse(row[:coverage_end_date]) rescue row[:coverage_end_date] end
         })
      end
      rows
    end

  end
end
