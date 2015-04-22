require 'forwardable'
require 'loopless_array'

class Logic
  extend Forwardable

  def_delegators :@grid, :cells

  def initialize(grid)
    @grid = grid
  end

  def step
    @x = 0
    @y = 0
    @live_generation = []
    @dead_generation = []
    scan
    @live_generation.map{|c| c.status = 1}
    @dead_generation.map{|c| c.status = 0}
  end

  private

  def neighbors
    filtered_map = []
    neighbor_map.recurse_each do |e|
      e[0] >= 0 &&
      e[0] < cells.size &&
      e[1] >= 0 &&
      e[1] < cells[e[0]].size &&
      filtered_map << cells[e[0]][e[1]]
    end
    filtered_map
  end

  def neighbor_map
    LooplessArray.new [
      [@x - 1, @y - 1],
      [@x - 1, @y    ],
      [@x - 1, @y + 1],
      [@x,     @y - 1],
      [@x,     @y + 1],
      [@x + 1, @y + 1],
      [@x + 1, @y    ],
      [@x + 1, @y + 1]
    ]
  end

  def neighbor_count
    neighbors.compact().map(&:status).reduce(:+)
  end

  def determine_status
    nc = neighbor_count

    ( nc <  2 || nc >  3 ) && @dead_generation << current_cell
    ( nc == 2 || nc == 3 ) && @live_generation << current_cell
    true
  end

  def scan
    cells_left? && determine_status && increment_position && scan
  end

  def cells_left?
    y_within_bounds? && x_within_bounds?
  end

  def current_cell
    cells[@x][@y]
  end

  def increment_position
    y_within_bounds? && @y += 1
    y_within_bounds? || ( @x += 1 ) && @y = 0
  end

  def y_within_bounds?
    cells[@x] && @y < cells[@x].size
  end

  def x_within_bounds?
    @x < cells.size
  end
end
