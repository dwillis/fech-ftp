module FecFTP
  class Candidate

    # corresponds to the FEC Candidate master file described here:
    # http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCandidateMaster.shtml

    def self.load(cycle)
      cols = [:candidate_id, :candidate_name, :party, :election_year, :office_state, :office, :district, :status, :committee_id, :street_one, :street_two, :city, :state, :zipcode]
      url = "ftp://ftp.fec.gov/FEC/#{cycle}/cn#{cycle.to_s.last(2)}.zip"
      t = RemoteTable.new url, :filename => "cn.txt", :col_sep => "|", :headers => cols
    end


  end
end
