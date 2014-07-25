require 'fech-ftp'
require 'minitest/autorun'

class TestCandidate < MiniTest::Test
  def setup
    detail_file = File.readlines('test/cn.txt').to_a
    candidate_detail = Fech::Candidate.new(2012, headers: Fech::Candidate::HEADERS[:detail][:headers])

    summary_file = File.readlines('test/webl.txt').to_a
    candidate_summary = Fech::Candidate.new(2012, headers: Fech::Candidate::HEADERS[:summary_current][:headers])

    @detail_row = candidate_detail.format_row(detail_file[3])
    @summary_row = candidate_summary.format_row(summary_file[3])
  end

  def test_candidate_id_loads_properly
    assert @detail_row.fetch(:candidate_id) == "H0AL05163"
  end

  def test_candidate_dollar_amts_are_floats
    assert_kind_of Float, @summary_row.fetch(:total_receipts)
  end

  def test_that_summary_creates_dates
    assert_equal Date.parse('11/27/2013'), @summary_row.fetch(:coverage_end_date)
  end
end