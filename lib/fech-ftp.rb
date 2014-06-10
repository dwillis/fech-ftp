require 'fech'
require "fech-ftp/version"
require "fech-ftp/ftp"
require "fech-ftp/committee"
require "fech-ftp/candidate"
require "fech-ftp/candidate_contribution"
require "fech-ftp/committee_contribution"
require "fech-ftp/headers"
require "net/ftp"
require 'zip'
require 'remote_table'
require 'american_date'
require 'csv'
require 'pry'

module Fech
  def self.retrieve_table(table, cycle, opts={})
    table = case table
            when :candidate_contribution
              CandidateContribution.new(cycle)
            when :candidate
              Candidate.new(cycle, opts[:type])
            when :committee
              Committee.new(cycle, opts[:type])
            when :committee_contribution
              CommitteeContribution.new(cycle, opts[:type])
            end

    table.fetch
  end

  class Utilities
    def self.write_to_csv(filename, headers, rows)
      CSV.open("#{filename}.csv", "w") do |csv|
        csv << headers
        rows.map{|r| csv << r.values}
      end
    end
  end
end
