module Fech
  class Committee < Table
    HEADERS = {
      detail: {
        file: 'cm',
        headers: [
          :committee_id, :committee_name, :treasurer, :street_one,
          :street_two,:city, :state, :zipcode, :designation, :type, :party,
          :filing_frequency, :category, :connected_organization, :candidate_id
        ]
      },
      summary_all: {
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
      }
    }
  end
end
