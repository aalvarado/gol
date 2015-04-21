describe GridBuilder do
  let( :size ) { [10,10] }
  let( :grid_builder ) { GridBuilder.new }

  describe :create do
    it 'returns a Grid instance' do
      expect( grid_builder.create(*size) ).to be_a Grid
    end
  end
end
