describe Grid do
  let( :grid_size ) { [3,3] }
  let( :gb ) { GridBuilder.new() }
  let( :grid ) { gb.create(*grid_size) }
  let( :cells ) { grid.cells }
  let( :cell_count_list ) do
    c = []

    grid.each_cell_neighbor_count do |cell, count|
      c << count
    end
    c
  end

  describe 'cells' do
    it 'is a LooplessArray' do
      expect( grid.cells ).to be_a LooplessArray
    end
  end

  describe 'each_cell_neighbor_count' do
    # [*][*][ ]
    # [ ][ ][ ]
    # [ ][ ][ ]
    #
    # count is
    #
    # [1][1][1]
    # [2][2][1]
    # [0][0][0]

    # In array form for counts
    let(:expected_cell_count_list) do
     [1,1,1,2,2,1,0,0,0]
    end


    before do
      cells[0][0].alive!
      cells[0][1].alive!
    end

    it 'iterates a list of a cell and returns a count of alive neighbors per cell' do
      expect( cell_count_list ).to eq expected_cell_count_list
    end
  end
end
