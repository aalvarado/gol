describe Cell do
  let( :cell ) { Cell.new }

  describe :status do
    it 'has a dead as default of 0 (dead)' do
      expect( cell.status ).to eql 0
    end
  end
end
