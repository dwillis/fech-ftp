# fech-ftp

A Ruby library for retrieving and parsing [bulk data downloads](http://classic.fec.gov/finance/disclosure/ftp_download.shtml) from the Federal Election Commission. While fech-ftp provides an API to some transaction data (contributions from a committee to a candidate and contributions between two committees), its main purpose is to provide a simple interface to the "[committee master](http://classic.fec.gov/finance/disclosure/metadata/DataDictionaryCommitteeMaster.shtml)" and "[candidate master](http://classic.fec.gov/finance/disclosure/metadata/DataDictionaryCandidateMaster.shtml)" files, with the ultimate goal of providing a way to connect individual transactions parsed by [Fech](https://github.com/NYTimes/Fech) with their canonical recipients.

fech-ftp is tested under Ruby 2.0.0, 2.1.X, 2.2.X, and 2.3.X.

Ironically, the FEC announced in late 2017 that it would be moving its bulk data files from an FTP server to S3. This library has been updated to work with that setup, so it performs exactly zero FTP requests.

## Installation

Add this line to your application's Gemfile:

    gem 'fech-ftp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fech-ftp

## Usage

Fech-FTP can be used by itself or in combination with Fech. To retrieve canonical details about candidates for an election cycle, pass the cycle into the following constructor:

```ruby
require 'fech-ftp'
cands = Fech::Candidate.detail(2018)
cands.first # => {:candidate_id=>"H0AL02087", :candidate_name=>"ROBY, MARTHA", :party=>"REP", :election_year=>"2018", :office_state=>"AL", :office=>"H", :district=>"02", :incumbent_challenger_status=>"I", :candidate_status=>"C", :committee_id=>"C00462143", :street_one=>"3260 BANKHEAD AVE", :street_two=>"", :city=>"MONTGOMERY", :state=>"AL", :zipcode=>"361062448"}
```

If you want to have the data transferred into an csv, add the property `format: :csv`, like so:

```ruby
Fech::Candidate.detail(2018, format: :csv)
```

You can specify the location that the FEC zip files opened by fech-ftp are downloaded by adding the property `location`, with an absolute path to an _existing_ directory that must include a trailing slash, like so:

```ruby
Fech::Candidate.detail(2018, location: "/tmp/fec/")
```

If you are using the [Sequel Gem](https://github.com/jeremyevans/sequel), you can pass in the DB table object as the `connection` property:

```ruby
Fech::Candidate.detail(2018, format: :db, connection: DB[:candidates])
```

Please note that it assumes the table object's columns == header properties for the data that gets passed in. Otherwise, an exception will be thrown.
To get around this, you can provide the `connection` property as an array, with the traditional `DB` constant value being the in the first element, followed by the table name:

```ruby
Fech::Candidate.detail(2018, format: :db, connection: [<DATABASE OBJECT>, :candidates])
```

The table will automatically be created, and then will be populated with the selected dataset. Also please note that it assumes there are no foreign keys. To add them, please follow the Sequel documentation guidelines for adding/altering foreign keys.

`Fech::Candidate` and `Fech::Committee` each have multiple datasets available and can be accessed using the corresponding method:

`Candidate` responds to `summary_current, summary_all, detail`
`Committee` responds to `linkage, summary_all, detail`

The following have only a single dataset but will respond to any of the above methods:

```ruby
Fech::CandidateContribution
Fech::IndividualContribution
Fech::CommitteeContribution
```

There are additional classes representing [PAC contributions to candidates](http://classic.fec.gov/finance/disclosure/metadata/DataDictionaryContributionstoCandidates.shtml) (`CandidateContribution`) and [transactions involving two committees](http://classic.fec.gov/finance/disclosure/metadata/DataDictionaryCommitteetoCommittee.shtml) (`CommitteeContribution`). Be advised that both of the FTP files loaded by these classes are large and can take minutes to parse. They are appropriately used for background processing or data loading purposes, not for providing a live API. Individual Contributions in particular runs in excess of 1-2 million rows of data (~ 200mb)

## Authors

* [Derek Willis](https://github.com/dwillis)
* [Matt Long](https://github.com/wismer)

## Contributing

1. Fork it ( http://github.com/dwillis/fech-ftp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
