require 'remote_table'
require 'american_date'
require 'minitest/autorun'

class TestCommittee < MiniTest::Unit::TestCase
  
  def setup
    detail_cols = [:committee_id, :committee_name, :treasurer, :street_one, :street_two, :city, :state, :zipcode, :designation, :type, :party, :filing_frequency, :category, :connected_organization, :candidate_id]
    detail = RemoteTable.new "file://#{File.expand_path('../cm.txt', __FILE__)}", :col_sep => "|", :headers => detail_cols
    @detail_rows = detail.entries

    summary_cols = [:committee_id, :committee_name, :type, :designation, :filing_frequency, :total_receipts, :transfers_from_affiliates, :individual_contributions, :pac_contributions, :candidate_contributions, 
    :candidate_loans, :total_loans_received, :total_disbursements, :transfers_to_affiliates, :individual_refunds, :committee_refunds, :candidate_loan_repayments, :loan_repayments, :beginning_year_cash, 
    :ending_cash, :debts_owed_by, :nonfederal_transfers_received, :contributions_to_committees, :independent_expenditures, :party_coordinated_expenditures, :nonfederal_share_expenditures, :coverage_end_date]
    summary = RemoteTable.new "file://#{File.expand_path('../webk.txt', __FILE__)}", :col_sep => "|", :headers => summary_cols
    @summary_rows = summary.entries
    @summary_rows.each do |row|
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
    @summary_rows
  end
  
  def test_that_committee_detail_is_properly_loaded
    assert_equal "NORFOLK SOUTHERN CORPORATION GOOD GOVERNMENT FUND", @detail_rows[1][:committee_name]
  end
  
  def test_that_summary_creates_dates
    assert_equal Date.parse('09/30/2013'), @summary_rows.first[:coverage_end_date]
  end

  def test_that_amount_cols_are_floats
    assert_kind_of Float, @summary_rows.first[:total_receipts]
  end
  
end