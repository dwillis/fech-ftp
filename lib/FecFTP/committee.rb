module FecFTP
  class Committee

    # corresponds to the FEC Committee master file described here:
    # http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCommitteeMaster.shtml

    def self.load(cycle)
      cols = [:committee_id, :committee_name, :treasurer, :street_one, :street_two, :city, :state, :zipcode, :designation, :type, :party, :filing_frequency, :category, :connected_organization, :candidate_id]
      url = "ftp://ftp.fec.gov/FEC/#{cycle}/cm#{cycle.to_s.last(2)}.zip"
      t = RemoteTable.new url, :filename => "cm.txt", :col_sep => "|", :headers => cols
    end


  end
end
