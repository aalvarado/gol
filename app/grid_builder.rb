require 'forwardable'

class GridBuilder
  extend Forwardable

  def_delegators :@grid, :cells

  def create(h_size, v_size)
    @grid = new_grid
    @grid.cells = create_rows(h_size, v_size)
    @grid
  end

  private

  def create_rows(h_size, v_size)
    LooplessArray.new((1..h_size).to_a).rmap do |i|
      LooplessArray.new((1..v_size).to_a).rmap do |ii|
        new_cell
      end
    end
  end

  def new_cell
    Cell.new()
  end

  def new_grid
    Grid.new
  end
end
