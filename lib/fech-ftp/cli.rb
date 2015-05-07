require 'thor'
require 'pry'
module Fech
  class CLI < Thor
    include Fech::Dispatcher
    # fech-ftp download individual 2012 --detail=format:csv
    # fech-ftp download committee -c 2012 --format=csv
    desc "Download individual records to <DIR> by specified election year", "Download individual records by year"
    method_option :format, :type => :string, :require => true, :alias => "-f"
    method_option :contributions, :alias => "-c", :default => ""
    method_option :year, :type => :numeric, :require => true, :alias => "-y"

    def download(table_name="", meth="")
      table = dataset(table_name, options[:contributions])
      opts = options.inject({}){|opt,(k,v)| opt[k.to_sym] = v; opt}
      opts[:format] = opts[:format].to_sym
      if table.respond_to? meth
        table.send(meth, options[:year], opts)
      else
        raise 'invalid method'
      end
    end
  end
end
