describe Cell do
  let( :cell ) { Cell.new }

  describe :status do
    it 'has a dead as default of 0 (dead)' do
      expect( cell.status ).to eql 0
    end

    it 'can be have a 1 status (alive) ' do
      cell.status = 1
      expect( cell.status ).to eql 1
    end
  end
end
