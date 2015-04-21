describe Grid do
  let( :grid ) { Grid.new }

  describe 'cells' do
    it 'is an array' do
      expect( grid.cells ).to be_an Array
    end
  end
end
