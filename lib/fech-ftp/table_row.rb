module Fech
  class TableRow
    def initialize(row, procs)
      @row   = row.split("|")
      @procs = procs
    end

    # the newline is automatically ignored since it's always n + 1 in the index
    # proc called with the cell's value and returns a 2 element array containing
    # [header, <formatted cell value>]
    # then gets concatenated into an array, and then implicitly turned into a
    # hash - { HEADER -> FORMATTED CELL }
    
    def merge(line=[])
      @procs.each { |blk| line += blk.call(@row.shift) }
      return Hash[line]
    end
  end
end
