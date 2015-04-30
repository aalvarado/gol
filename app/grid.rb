class Grid
  attr_accessor :cells

  def initialize
    @cells = LooplessArray.new
  end

  def each_cell_neighbor_count(&block)
    each_cell(&block)
  end

  private

  def each_cell(&block)
    cells.recurse_each_with_index do |row, x|
      row.recurse_each_with_index do |cell, y|
        block.call(cell, neighbor_live_count(x, y))
      end
    end
  end

  def neighbor_live_count(x, y)
    count = 0
    neighbors(x, y).rmap(&:status).recurse_each do |status|
      count += status
    end
    count
  end

  def neighbors(x, y)
    filtered_neighbors = LooplessArray.new
    neighbor_map(x, y).recurse_each do |c|
      bounds_check_neighbors(c) && filtered_neighbors << cells[c[0]][c[1]]
    end
    filtered_neighbors
  end

  def neighbor_map(x, y)
    LooplessArray.new [
      [x - 1, y - 1], [x - 1, y], [x - 1, y + 1],
      [x, y - 1], [x, y + 1],
      [x + 1, y - 1], [x + 1, y], [x + 1, y + 1]
    ]
  end

  def bounds_check_neighbors(coords)
    coords[0] >= 0 &&
      coords[0] < cells.size &&
      coords[1] >= 0 &&
      coords[1] < cells[coords[0]].size
  end
end
