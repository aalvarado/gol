require 'forwardable'

class GridBuilder
  extend Forwardable

  def_delegators :@grid, :cells

  def create(h_size, v_size)
    @h_size = h_size
    @v_size = v_size
    @row = 0
    @grid = new_grid
    initialize_cells
    @grid
  end

  private

  def initialize_cells
    create_rows && initialize_cells
  end

  def create_rows
    rows_within_range? && create_row && increment_row
  end

  def create_row
    cells[@row] = [ new_cell ] * @v_size
  end

  def rows_within_range?
    @row < @h_size
  end

  def increment_row
    @row += 1
  end

  def new_cell
    Cell.new()
  end

  def new_grid
    Grid.new
  end
end
