module Fech
  class Ftp < Thor
    include Dispatcher

    desc "Download individual records to <DIR> by specified election year", "Download individual records by year"
    # fech-ftp download individual 2012 --detail=format:csv
    # fech-ftp download committee -c 2012 --format=csv
    method_option :format, :type => :string, :require => true, :alias => "-f"
    method_option :contributions, :alias => "-c", :default => ""

    def download(table_name="", meth="")
      table = dataset(table_name, options[:contributions])
      table.send(meth, options)
    end
  end
end
