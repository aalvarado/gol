require 'forwardable'
require 'loopless_array'

class Logic
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
    @live_generation.recurse_each{ |c| c.status = 1 }
    @dead_generation.recurse_each{ |c| c.status = 0 }
  end


  def determine_status
    nc = neighbor_count
    ( nc <  2 || nc >  3 ) && @dead_generation << current_cell
    ( nc == 2 || nc == 3 ) && @live_generation << current_cell
  end

  def scan_cells
  end
end
