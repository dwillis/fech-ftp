module Fech
  class InvalidTable < StandardError
    def initialize(table)
      @table = table
    end

    def message
      "the table #{@table} does not exist. For a list of all tables, type `$ fech-ftp help` for the available options"
    end
  end
end
