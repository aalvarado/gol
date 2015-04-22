require 'forwardable'

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
    [
      cells[@x - 1][@y - 1], cells[@x - 1][@y    ], cells[@x - 1][@y + 1],
      cells[@x][    @y - 1],                        cells[@x][    @y + 1],
      cells[@x + 1][@y - 1], cells[@x + 1][@y    ], cells[@x + 1][@y + 1]
    ]
  end

  def neighbor_count
    neighbors.compact().map(&:status).reduce(:+)
  end

  def determine_status
    nc = neighbor_count

    nc <  2 && @dead_generation << current_cell
    ( nc == 2 || nc == 3 ) && @live_generation << current_cell
    nc > 3 && @dead_generation << current_cell
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
    y_within_bounds?  && @y += 1
    !y_within_bounds? && @x += 1 && @y = 0
  end

  def y_within_bounds?
    @y < cells[@x].size
  end

  def x_within_bounds?
    @x < cells.size
  end
end
