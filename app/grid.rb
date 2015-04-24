class Grid
  attr_accessor :cells

  def initialize
    @cells = LooplessArray.new
  end

  def living_neighbor_cells(x, y)
    @x = x
    @y = y
    neighbors.compact().rmap(&:status).reduce(:+)
  end

  private

  def neighbors
    filtered_neighbors = LooplessArray.new
    neighbor_map.recurse_each do |e|
      bounds_check_neighbors(e) && filtered_neighbors << cells[e[0]][e[1]]
    end
    filtered_neighbors
  end

  def neighbor_map
    LooplessArray.new [
      [@x - 1, @y - 1], [@x - 1, @y    ], [@x - 1, @y + 1],
      [@x,     @y - 1], [@x,     @y + 1],
      [@x + 1, @y + 1], [@x + 1, @y    ], [@x + 1, @y + 1]
    ]
  end

  def bounds_check_neighbors coords
    coords[0] >= 0 &&
    coords[0] < cells.size &&
    coords[1] >= 0 &&
    coords[1] < cells[ coords[0] ].size
  end
end
