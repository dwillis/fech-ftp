module Fech
  module CLIFileHelper
    def process_request(tables, destination, options={})
      tables.each do |table|
        fec_table = Table.new(destination, table.merge(options))
        fec_table.download_table_data

        if fec_table.export_format == 'csv'
          puts "#{fec_table.export_filename}.csv placed in #{destination}."
        end
      end
    end
  end
end
