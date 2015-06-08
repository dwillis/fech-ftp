require 'fech-ftp'
require 'minitest/autorun'
require 'pry'
class TestCandidate < MiniTest::Test
  def setup
    @summary_table = Fech::Table.new('candidate', year: 2012, format: 'csv', subtable: 'summary')
    @detail_table  = Fech::Table.new('candidate', year: 2012, format: 'csv', subtable: 'detail')
    @summary_table << File.open('./test/webl.txt', 'r')
    @detail_table  << File.open('./test/cn.txt', 'r')
  end

  def test_table_loads_ten_lines_of_data
    assert @detail_table.lines.length, 10
  end

  def test_candidate_id_is_correct
    mo_brooks = @detail_table.lines[3]
    assert mo_brooks.candidate_id == "H0AL05163"
  end

  def test_struct_name_is_candidate_detail
    assert_kind_of Struct::CandidateDetail, @detail_table.lines[0]
  end

  def test_struct_name_is_candidate_summary
    assert_kind_of Struct::CandidateSummary, @summary_table.lines[0]
  end

  def test_candidate_dollar_amts_are_floats
    line = @summary_table.lines[3]
    assert_kind_of Float, line.total_receipts
  end
end
