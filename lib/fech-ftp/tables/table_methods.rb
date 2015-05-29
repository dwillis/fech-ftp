module Fech
  class Table
    def method_missing(meth)
      
      table = new(cycle, self::HEADERS[:detail])
      table.retrieve_data.select { |candidate| candidate[:party] == meth.upcase }
    end
  end
end
