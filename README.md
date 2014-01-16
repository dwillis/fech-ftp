# Fech-FTP

A Ruby library for retrieving and parsing [FTP data downloads](http://www.fec.gov/finance/disclosure/ftp_download.shtml) from the Federal Election Commission. Heavily dependent on the Remote Table gem. While Fech-FTP provides an API to some transaction data (contributions from a committee to a candidate and contributions between two committees), its main purpose is to provide a simple interface to the "[committee master](http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCommitteeMaster.shtml)" and "[candidate master](http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCandidateMaster.shtml)" files, with the ultimate goal of providing a way to connect individual transactions parsed by [Fech](https://github.com/NYTimes/Fech) with their canonical recipients.

Fech-FTP is tested under Ruby 1.9.3, 2.0.0 and 2.1.0. 

## Installation

Add this line to your application's Gemfile:

    gem 'fech-ftp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fech-ftp

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/dwillis/fech-ftp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
