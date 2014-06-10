module Fech
  class Committee < FechFTP
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
          :candidate_id, :candidate_election_year, :election_year,
          :committee_id, :type, :designation, :linkage_id
        ]
      }
    }
  end

  class Candidate < FechFTP
    HEADERS = {
      detail: {
        file: 'cn',
        headers: [
          :candidate_id, :candidate_name, :party, :election_year,
          :office_state, :office, :district, :incumbent_challenger_status,
          :candidate_status, :committee_id, :street_one, :street_two, :city,
          :state, :zipcode
        ]
      },
      summary_current: {
        file: 'webl',
        headers: [
          :candidate_id, :candidate_name, :status, :party_code, :party,
          :total_receipts, :transfers_from_authorized, :total_disbursements,
          :transfers_to_authorized, :beginning_cash, :ending_cash, :candidate_contributions,
          :candidate_loans, :other_loans, :candidate_loan_repayments, :other_loan_repayments,
          :debts_owed_by, :total_individual_contributions, :office_state, :district,
          :special_election_status, :primary_election_status, :runoff_election_status,
          :general_election_status, :general_election_percent, :pac_contributions,
          :party_contributions, :coverage_end_date, :individual_refunds, :committee_refunds
        ]
      },
      summary_all: {
        file: 'weball',
        headers: [
          :candidate_id, :candidate_name, :status, :party_code, :party,
          :total_receipts, :transfers_from_authorized, :total_disbursements,
          :transfers_to_authorized, :beginning_cash, :ending_cash, :candidate_contributions,
          :candidate_loans, :other_loans, :candidate_loan_repayments, :other_loan_repayments,
          :debts_owed_by, :total_individual_contributions, :office_state, :district,
          :special_election_status, :primary_election_status, :runoff_election_status,
          :general_election_status, :general_election_percent, :pac_contributions,
          :party_contributions, :coverage_end_date, :individual_refunds, :committee_refunds
        ]
      }
    }
  end
end