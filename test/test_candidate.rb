require 'remote_table'
require 'american_date'
require 'minitest/autorun'

class TestCandidate < MiniTest::Unit::TestCase
  
  def setup
    detail_cols = [:candidate_id, :candidate_name, :party, :election_year, :office_state, :office, :district, :status, :committee_id, :street_one, :street_two, :city, :state, :zipcode]
    detail = RemoteTable.new "file://#{File.expand_path('../cn.txt', __FILE__)}", :col_sep => "|", :headers => detail_cols
    @detail_rows = detail.entries

    summary_cols = [:candidate_id, :candidate_name, :status, :party_code, :party, :total_receipts, :transfers_from_authorized, :total_disbursements, :transfers_to_authorized, :beginning_cash, 
        :ending_cash, :candidate_contributions, :candidate_loans, :other_loans, :candidate_loan_repayments, :other_loan_repayments, :debts_owed_by, :total_individual_contributions, 
        :office_state, :district, :special_election_status, :primary_election_status, :runoff_election_status, :general_election_status, :general_election_percent, :pac_contributions, 
        :party_contributions, :coverage_end_date, :individual_refunds, :committee_refunds]
    summary = RemoteTable.new "file://#{File.expand_path('../webl.txt', __FILE__)}", :col_sep => "|", :headers => summary_cols
    @summary_rows = summary.entries
    @summary_rows.each do |row|
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
    @summary_rows
  end
  
  def test_that_candidate_detail_is_properly_loaded
    assert_equal "ROBY, MARTHA", @detail_rows[1][:candidate_name]
  end
  
  def test_that_summary_creates_dates
    assert_equal Date.parse('09/30/2013'), @summary_rows.first[:coverage_end_date]
  end

  def test_that_amount_cols_are_floats
    assert_kind_of Float, @summary_rows.first[:total_receipts]
  end
  
end