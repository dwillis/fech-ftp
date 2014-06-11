require 'fech'
require "fech-ftp/version"
require "fech-ftp/ftp"
require "fech-ftp/committee"
require "fech-ftp/candidate"
require "fech-ftp/candidate_contribution"
require "fech-ftp/committee_contribution"
require "fech-ftp/individual_contribution"
require "fech-ftp/headers"
require "net/ftp"
require 'zip'
require 'remote_table'
require 'american_date'
require 'csv'
require 'pry'

module Fech
  def self.retrieve_table(table, cycle, opts={})
    fetch = case table
            when :candidate_contribution
              CandidateContribution.new(cycle, opts)
            when :candidate
              Candidate.new(cycle, opts)
            when :committee
              Committee.new(cycle, opts)
            when :committee_contribution
              CommitteeContribution.new(cycle, opts)
            when :individual_contribution
              IndividualContribution.new(cycle, opts)
            else
              raise 'Invalid options selected'
            end

    if opts[:mode] == :to_csv
      headers = if fetch.class::HEADERS.is_a?(Hash)
                  fetch.class::HEADERS[opts[:type]][:headers]
                else
                  fetch.class::HEADERS
                end

      csv = CSV.open("#{table}-#{cycle}-#{opts[:type]}.csv", 'a+', headers: headers, write_headers: true)
    end
    fetch.table(csv)
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
