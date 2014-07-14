module Fech
  class Candidate < Table
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

