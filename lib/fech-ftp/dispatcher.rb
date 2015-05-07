module Fech
  module Dispatcher
    def dataset(table, subset)
      table = "#{table.capitalize}#{subset.capitalize}"
      if Fech.const_defined?(table)
        Fech.const_get("#{table.capitalize}#{subset.capitalize}")
      else
        raise 'Invalid table'
      end
    end
  end
end
