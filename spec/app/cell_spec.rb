describe Cell do
  let( :cell ) { Cell.new(0,0) }

  describe :position do
    it 'has position as an attribute' do
      expect( cell.position ).to eql [0,0]
    end
  end
end
