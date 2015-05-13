module Fech
  class Table
    class_eval do
      [:detail, :summary_all, :linkage, :summary_current].each do |meth|
        action = lambda do |cycle, opts={}|
          attrs = self::HEADERS[meth] || self::HEADERS
          attrs.merge!(opts)
          table = new(cycle, attrs)
          table.parse!
          table.save
        end

        define_singleton_method(meth, action)
      end
    end

    def method_missing(meth, cycle)
      table = new(cycle, self::HEADERS[:detail])
      table.retrieve_data.select { |candidate| candidate[:party] == meth.upcase }
    end
  end
end
