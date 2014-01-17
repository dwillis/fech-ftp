require 'fech'
require "fech-ftp/version"
require "fech-ftp/committee"
require "fech-ftp/candidate"
require "fech-ftp/candidate_contribution"
require "fech-ftp/committee_contribution"
require 'remote_table'
require 'american_date'
require 'csv'

module Fech
  class Utilities

    def self.write_to_csv(filename, headers, rows)
      CSV.open("#{filename}.csv", "w") do |csv|
        csv << headers
        rows.map{|r| csv << r.values}
      end
    end
  end
end