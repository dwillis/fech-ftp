require 'fech'
require 'fech-ftp/version'
require 'fech-ftp/cli_helper'
require 'fech-ftp/cli'
require 'fech-ftp/table'
require 'fech-ftp/fech_ftp'
require 'net/ftp'
require 'zip'
require 'yaml'
require 'active_support'
require 'active_support/deprecation'
require 'remote_table'
require 'american_date'
require 'sqlite3'
require 'sequel'
require 'csv'

module Fech
  FTP_SETTINGS = YAML.load_file('config.yaml')
  class Utilities
    def self.superpacs
      url = "http://www.fec.gov/press/press2011/ieoc_alpha.shtml"
      t = RemoteTable.new url, :row_xpath => '//table/tr', :column_xpath => 'td', :encoding => 'windows-1252', :headers => %w{ row_id committee_id committee_name filing_frequency}
      t.entries
    end
  end
end
