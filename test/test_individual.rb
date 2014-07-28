require 'fech-ftp'
require 'minitest/autorun'

class TestIndividual < Minitest::Test
  def setup
    indiv_file = File.readlines('test/itcont.txt').to_a
    indiv_table = Fech::IndividualContribution.new(2012, headers: Fech::IndividualContribution::HEADERS[:headers])

    @row = indiv_table.format_row(indiv_file[0])
  end

  def test_dollar_amts_are_floats
    assert_kind_of Float, @row.fetch(:trans_amount)
  end

  def test_filing_id_are_integers
    assert_kind_of Integer, @row.fetch(:filing_id)
  end

  def test_date_parses_properly
    assert_equal Date.strptime('01232011', "%m%d%Y"), @row.fetch(:trans_date)
  end

  def test_fec_record_number_matches
    assert_equal "4021720111136021419", @row.fetch(:fec_record_number)
  end
end