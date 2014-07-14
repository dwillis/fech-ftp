module Fech
  class Table
    class_eval do
      [:detail, :summary_all, :linkage, :summary_current].each do |meth|
        action = lambda do |cycle, opts={}|
          attrs = self::HEADERS[meth] || self::HEADERS
          attrs.merge!(opts)
          table = new(cycle, attrs)
          table.retrieve_data
        end

        define_singleton_method(meth, action)
      end
    end
  end
end