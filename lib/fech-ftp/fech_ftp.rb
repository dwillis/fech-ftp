module Fech
  class FTP
    include CLIFileHelper

    def fetch_fec_file(table, year, opts={})
      @table = Table.new(table, {
          :year        => year,
          :subtable    => opts[:subtable]    || 'summary',
          :destination => opts[:destination] || '.',
          :format      => opts[:format]      || 'to_rb_obj'
        }
      )

      download_table_data
      @table.export
    end
  end
end
