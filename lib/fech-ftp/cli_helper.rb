module Fech
  FTP_SETTINGS = YAML.load_file('config.yaml')
  # DB = Sequel.sqlite
  module CLIFileHelper
    def process_request(tables, destination, options={})
      tables.each do |table|
        fec_table = Table.new(destination, table.merge(options))
        fec_table.download_table_data unless fec_table.zip_downloaded?
        fec_table.decompress
      end
    end

    def initialize_db_tables(primary_table, tables)
      DB.create_table(primary_table.to_sym) { primary_key :id }

      tables.each do |table|
        db_properties = table['dbtable']
        DB.create_table db_properties[:table_name] do
          primary_key :id
          db_properties[:foreign_keys].each do |key|
            foreign_key key, primary_table.to_sym
          end
        end
      end
    end

    def db_prompt(opts={})
      # TODO
    end

    def set_db(opts={})
      # TODO
    end
  end
end
