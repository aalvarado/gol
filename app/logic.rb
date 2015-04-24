require 'forwardable'
require 'loopless_array'

class Logic
  extend Forwardable

  def_delegators :@grid, :neighbor_live_count

  def initialize(grid)
    @grid = grid
  end

  def step
    initialize_step
    scan_cells
    apply_cell_changes
  end

  private

  def initialize_step
    @live_generation = LooplessArray.new
    @dead_generation = LooplessArray.new
  end

  def apply_cell_changes
    @live_generation.recurse_each{ |c| c.alive! }
    @dead_generation.recurse_each{ |c| c.dead!  }
  end

  # Less than 2 cells or more than 3 neighbor cells
  # the cell dies
  #
  #
  def determine_status cell, neighbor_live_count
    nc = neighbor_live_count
    ( nc <  2 || nc >  3 ) && @dead_generation << cell
    ( nc == 3 )            && @live_generation << cell
  end

  def scan_cells
    @grid.each_cell_count do |cell, nl_count|
      determine_status(cell, nl_count)
    end
  end
end
