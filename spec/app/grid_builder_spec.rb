describe GridBuilder do
  let(:size) { [10, 10] }
  let(:grid_builder) { GridBuilder.new }
  let(:grid) { grid_builder.create(*size) }
  let(:cells) { grid.cells }

  describe :create do
    it 'returns a Grid instance' do
      expect(grid_builder.create(*size)).to be_a Grid
    end

    it 'returns a grid with the specified cell row count' do
      expect(cells.size).to eql size[0]
    end

    it 'returns a grid with specified cell column count' do
      cells.recurse_each do |elems|
        expect(elems.size).to eql size[1]
      end
    end

    it 'sets grid.cells as Cells' do
      cells.recurse_each do |r|
        r.recurse_each { |c| expect(c.class).to eql Cell }
      end
    end
  end
end
