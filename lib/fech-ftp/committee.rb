module Fech
  class Committee
    HEADERS = {
      detail: {
        file: 'cm',
        headers: [
          :committee_id, :committee_name, :treasurer, :street_one,
          :street_two,:city, :state, :zipcode, :designation, :type, :party,
          :filing_frequency, :category, :connected_organization, :candidate_id
        ]
      },
      summary: {
        file: 'webk',
        headers: [
          :committee_id, :committee_name, :type, :designation, :filing_frequency,
          :total_receipts, :transfers_from_affiliates, :individual_contributions,
          :pac_contributions, :candidate_contributions, :candidate_loans,
          :total_loans_received, :total_disbursements, :transfers_to_affiliates,
          :individual_refunds, :committee_refunds, :candidate_loan_repayments,
          :loan_repayments, :beginning_year_cash, :ending_cash, :debts_owed_by,
          :nonfederal_transfers_received, :contributions_to_committees,
          :independent_expenditures, :party_coordinated_expenditures,
          :nonfederal_share_expenditures, :coverage_end_date
        ]
      },

      linkage: {
        file: 'ccl',
        headers: [
          :committee_id, :candidate_election_year, :election_year,
          :candidate_id, :type, :designation, :linkage_id
        ]
      },

      load_superpacs: {
        file: '',
        headers: %w{ row_id committee_id committee_name filing_frequency}
      }
    }

    def self.load_superpacs
      url = "http://www.fec.gov/press/press2011/ieoc_alpha.shtml"
      t = RemoteTable.new url, :row_xpath => '//table/tr', :column_xpath => 'td', :encoding => 'windows-1252', :headers => HEADERS[:load_superpacs][:headers]
      t.entries
    end
  end
end
