# require 'fech'
require "fech-ftp/version"
require "fech-ftp/table"
require "fech-ftp/committee"
require "fech-ftp/candidate"
require "fech-ftp/candidate_contribution"
require "fech-ftp/committee_contribution"
require "fech-ftp/individual_contribution"
# require "fech-ftp/headers"
require "net/ftp"
require 'zip'
require 'remote_table'
require 'american_date'
require 'csv'
require 'pry'

module Fech
  class Utilities
    def self.retrieve_table(klass, opts={})
      type = klass::HEADERS[opts[:type]] || klass::HEADERS

      if opts[:remote]
        opts[:remote] = klass.load_superpacs
        opts[:file] = ''
      else
        opts[:file] = type[:file] + "#{opts[:cycle].to_s[2..3]}.zip"
      end

      opts[:headers] = type[:headers]

      if opts[:mode] == :to_csv
        opts[:receiver] = CSV.open("#{opts[:file].gsub(/\.zip$/, '')}#{opts[:type]}.csv", 'a+', headers: opts[:headers], write_headers: true)
      elsif opts[:mode] == :to_db
        # DB object that accepts << as a method, and the data as a hash (with column names as keys)
        opts[:receiver] = opts[:db]
      end

      table = Table.new(opts)
      table.retrieve_data
    end
  end
end
