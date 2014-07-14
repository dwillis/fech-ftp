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

Fech-FTP can be used by itself or in combination with Fech. To retrieve canonical details about candidates for an election cycle, pass the cycle into the following constructor:

```ruby
2.1.0 :001 > require 'fech-ftp'
2.1.0 :002 > cands = Fech::Candidate.detail(2014)
2.1.0 :003 > cands.first
=> {:candidate_id=>"H0AK00097", :candidate_name=>"COX, JOHN ROBERT", :party=>"REP", :election_year=>"2012", :office_state=>"AK", :office=>"H", :district=>"00", :incumbent_challenger_status=>"C", :candidate_status=>"N", :committee_id=>"C00525261", :street_one=>"PO BOX 1092", :street_two=>"", :city=>"ANCHOR POINT", :state=>"AK", :zipcode=>"995561092"}
```

If you want to have the data transferred into an csv, add the option `mode: :to_csv`, like so:

```
Fech::Candidate.detail(2014, mode: :to_csv)
```

The filename of the csv file will match the FEC's naming conventions.

Similarly, for committee details:

```ruby
2.1.0 :004 > cmtes = Fech::Committee.detail(2014)
2.1.0 :005 > cmtes[500]
 => {:committee_id=>"C00089086", :committee_name=>"THE AMERICAN OCCUPATIONAL THERAPY ASSOCIATION, INC. POLITICAL ACTION COMMITTEE (AOTPAC)", :treasurer=>"METZLER, CHRISTINA A.", :street_one=>"4720 MONTGOMERY LANE, SUITE 200", :street_two=>"", :city=>"BETHESDA", :state=>"MD", :zipcode=>"208143449", :designation=>"B", :type=>"Q", :party=>"", :filing_frequency=>"M", :category=>"M", :connected_organization=>"THE AMERICAN OCCUPATIONAL THERAPY ASSOCIATION, INC.", :candidate_id=>""}
```

Both candidates and committees have summary methods that return fundraising information about candidates and committees:

```ruby
2.1.0 :006 > candsumm = Fech::Candidate.current_summary(2014) # current candidates only
2.1.0 :007 > candsumm.first
 => {:candidate_id=>"H2AK00101", :candidate_name=>"MOORE, MATTHEW EDWARD", :status=>"C", :party_code=>"1", :party=>"DEM", :total_receipts=>15749.5, :transfers_from_authorized=>0.0, :total_disbursements=>13376.95, :transfers_to_authorized=>0.0, :beginning_cash=>0.0, :ending_cash=>2372.55, :candidate_contributions=>0.0, :candidate_loans=>12000.0, :other_loans=>0.0, :candidate_loan_repayments=>0.0, :other_loan_repayments=>0.0, :debts_owed_by=>12100.0, :total_individual_contributions=>3741.5, :office_state=>"AK", :district=>"00", :special_election_status=>"", :primary_election_status=>"", :runoff_election_status=>"", :general_election_status=>"", :general_election_percent=>0.0, :pac_contributions=>0.0, :party_contributions=>0.0, :coverage_end_date=>Mon, 30 Sep 2013, :individual_refunds=>0.0, :committee_refunds=>0.0}
2.1.0 :008 > cmtesumm = Fech::Committee.summary(2014)
2.1.0 :009 > cmtesumm[6000]
 => {:committee_id=>"C00324103", :committee_name=>"NCR CORPORATION POLITICAL ACTION COMMITTEE (NCRPAC)", :type=>"Q", :designation=>"B", :filing_frequency=>"M", :total_receipts=>12426.5, :transfers_from_affiliates=>0.0, :individual_contributions=>12426.5, :pac_contributions=>0.0, :candidate_contributions=>0.0, :candidate_loans=>0.0, :total_loans_received=>0.0, :total_disbursements=>8000.0, :transfers_to_affiliates=>0.0, :individual_refunds=>0.0, :committee_refunds=>0.0, :candidate_loan_repayments=>0.0, :loan_repayments=>0.0, :beginning_year_cash=>16721.66, :ending_cash=>21148.16, :debts_owed_by=>0.0, :nonfederal_transfers_received=>0.0, :contributions_to_committees=>7000.0, :independent_expenditures=>0.0, :party_coordinated_expenditures=>0.0, :nonfederal_share_expenditures=>0.0, :coverage_end_date=>Sat, 30 Nov 2013}
```

There are additional classes representing [PAC contributions to candidates](http://www.fec.gov/finance/disclosure/metadata/DataDictionaryContributionstoCandidates.shtml) (`CandidateContribution`) and [transactions involving two committees](http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCommitteetoCommittee.shtml) (`CommitteeContribution`). Be advised that both of the FTP files loaded by these classes are large and can take minutes to parse. They are appropriately used for background processing or data loading purposes, not for providing a live API.

## Contributing

1. Fork it ( http://github.com/dwillis/fech-ftp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
