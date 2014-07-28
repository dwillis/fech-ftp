require 'fech-ftp'
require 'minitest/autorun'

class TestCommittee < MiniTest::Test
  def setup
    detail_file = File.readlines('test/cm.txt').to_a
    cm_detail   = Fech::Committee.new(2012, headers: Fech::Committee::HEADERS[:detail][:headers])

    summary_file = File.readlines('test/webk.txt').to_a
    cm_summary   = Fech::Committee.new(2012, headers: Fech::Committee::HEADERS[:summary_all][:headers])

    @summary_row = cm_summary.format_row(summary_file[1])
    @detail_row  = cm_detail.format_row(detail_file[1])
  end

  def test_that_committee_detail_is_properly_loaded
    assert_equal "NORFOLK SOUTHERN CORPORATION GOOD GOVERNMENT FUND", @detail_row.fetch(:committee_name)
  end

  def test_that_summary_creates_dates
    assert_equal Date.parse('06/30/2013'), @summary_row.fetch(:coverage_end_date)
  end

  def test_that_amount_cols_are_floats
    assert_kind_of Float, @summary_row.fetch(:total_receipts)
  end
end