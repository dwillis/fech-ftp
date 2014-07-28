# Fech-FTP

A Ruby library for retrieving and parsing [FTP data downloads](http://www.fec.gov/finance/disclosure/ftp_download.shtml) from the Federal Election Commission. While Fech-FTP provides an API to some transaction data (contributions from a committee to a candidate and contributions between two committees), its main purpose is to provide a simple interface to the "[committee master](http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCommitteeMaster.shtml)" and "[candidate master](http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCandidateMaster.shtml)" files, with the ultimate goal of providing a way to connect individual transactions parsed by [Fech](https://github.com/NYTimes/Fech) with their canonical recipients.

Fech-FTP is tested under Ruby 1.9.3, 2.0.0 and 2.1.0.

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
cands = Fech::Candidate.detail(2014)
cands.first # => {:candidate_id=>"H0AK00097", :candidate_name=>"COX, JOHN ROBERT", :party=>"REP", :election_year=>"2012", :office_state=>"AK", :office=>"H", :district=>"00", :incumbent_challenger_status=>"C", :candidate_status=>"N", :committee_id=>"C00525261", :street_one=>"PO BOX 1092", :street_two=>"", :city=>"ANCHOR POINT", :state=>"AK", :zipcode=>"995561092"}
```

If you want to have the data transferred into an csv, add the property `format: :csv`, like so:

```ruby
Fech::Candidate.detail(2014, format: :csv)
```

If you are using the [Sequel Gem](https://github.com/jeremyevans/sequel), you can pass in the DB table object as the `connection` property:

```ruby
Fech::Candidate.detail(2014, format: :db, connection: DB[:candidates])
```

Please note that it assumes the table object's columns == header properties for the data that gets passed in. Otherwise, an exception will be thrown.
To get around this, you can provide the `connection` property as an array, with the traditional `DB` constant value being the in the first element, followed by the table name:

```ruby
Fech::Candidate.detail(2014, format: :db, connection: [<DATABASE OBJECT>, :candidates])
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

There are additional classes representing [PAC contributions to candidates](http://www.fec.gov/finance/disclosure/metadata/DataDictionaryContributionstoCandidates.shtml) (`CandidateContribution`) and [transactions involving two committees](http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCommitteetoCommittee.shtml) (`CommitteeContribution`). Be advised that both of the FTP files loaded by these classes are large and can take minutes to parse. They are appropriately used for background processing or data loading purposes, not for providing a live API. Individual Contributions in particular runs in excess of 1-2 million rows of data (~ 200mb)

## Contributing

1. Fork it ( http://github.com/dwillis/fech-ftp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
