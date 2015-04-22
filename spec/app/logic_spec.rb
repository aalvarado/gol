describe Logic do
  let( :size ) { [3,3] }
  let( :gb ) { GridBuilder.new }
  let( :grid ) { gb.create(*size) }
  let( :cells ) { grid.cells }
  let( :logic ) { Logic.new(grid) }

  describe "Any live cell with fewer than two live neighbours " do
    before do
      cells[0][0].status = 1
      cells[1][1].status = 1
      logic.step
    end

    it 'dies' do
      expect( cells[1][1].status ).to be 0
    end
  end

  describe "Any live cell with two or three live neighbours lives on to the next generation." do
  end

  describe "Any live cell with more than three live neighbours dies, as if by overcrowding." do
  end

  describe "Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction." do

  end
end
