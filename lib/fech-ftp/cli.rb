require 'thor'
require 'pry'
module Fech
  class CLI < Thor
    # fech-ftp download individual 2012 --detail=format:csv
    # fech-ftp download committee -c 2012 --format=csv
    desc "Download individual records to <DIR> by specified election year", "Download individual records by year"
    method_option :format, :type => :string, :require => true, :alias => "-f"
    method_option :contributions, :alias => "-c", :default => ""
    method_option :year, :type => :numeric, :require => true, :alias => "-y"
    method_option :source, :type => :string, :alias => "-s"

    def download(table_name, meth, dest=".")
      table = find_table(table_name, options[:contributions])
      opts = options.inject({}){|opt,(k,v)| opt[k.to_sym] = v; opt}
      opts[:format] = opts[:format].to_sym
      if table.respond_to? meth
        table_klass = table.send(meth, options[:year], opts)
        table_klass.download
      else
        raise 'invalid method'
      end
    end
  end

  private

  def find_table(table, subset)
    table = "#{table.capitalize}#{subset.capitalize}"
    if Fech.const_defined?(table)
      Fech.const_get("#{table.capitalize}#{subset.capitalize}")
    else
      raise 'Invalid table'
    end
  end
end
