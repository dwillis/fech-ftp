module Fech
  class CandidateContribution < Table
    HEADERS = {
      file: "oth",
      headers: [
        :committee_id, :amendment, :report_type, :primary_general, :microfilm,
        :transaction_type, :entity_type, :name, :city, :state, :zipcode,
        :employer, :occupation, :transaction_date, :amount, :other_committee_id, :candidate_id,
        :transaction_id, :filing_id, :memo_code, :memo_text, :fec_record_number
      ]
    }
  end
end
