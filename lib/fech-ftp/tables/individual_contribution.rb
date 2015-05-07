module Fech
  class IndividualContribution < Table
    HEADERS = {
      file: 'indiv',
      headers: [
        :committee_id, :amendment_indicator, :report_type, :election_type,
        :image_number, :trans_type, :entity_type, :name, :city, :state, :zip,
        :employer, :occupation, :trans_date, :trans_amount, :other_id, :trans_id,
        :filing_id, :memo_cd, :memo_txt, :fec_record_number
      ]
    }
  end
end