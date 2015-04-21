describe Cell do
  let( :cell ) { Cell.new }

  describe :new do
    it 'takes two positional parameters' do
      cell = Cell.new(0,0)
      expect( cell.position ).to eql [0,0]
    end
  end

  describe :position do
    it 'takes two parameters' do
      cell.set_position(1, 1)
      expect( cell.position ).to eql [0,0]
    end
  end
end
