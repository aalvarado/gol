describe Cell do
  let(:cell) { Cell.new }

  describe :status do
    it 'has a dead as default of 0 (dead)' do
      expect(cell.status).to eql 0
    end

    it 'can be have a 1 status (alive) ' do
      cell.status = 1
      expect(cell.status).to eql 1
    end
  end

  describe 'alive?' do
    it 'returns true if cell is alive' do
      cell.alive!
      expect(cell.alive?).to eq true
    end

    it 'returns false if cell is dead' do
      cell.dead!
      expect(cell.alive?).to eq false
    end
  end
end
