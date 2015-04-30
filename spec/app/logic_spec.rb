describe Logic do
  let(:size) { [3, 3] }
  let(:gb) { GridBuilder.new }
  let(:grid) { gb.create(*size) }
  let(:cells) { grid.cells }
  let(:logic) { Logic.new(grid) }

  describe 'Any live cell with fewer than two live neighbours' do
    # 1 = alive
    #
    # [1][0][0]
    # [0][1][0]
    # [0][0][0]
    #
    # after step
    #
    # [0][0][0]
    # [0][0][0]
    # [0][0][0]

    before do
      cells[0][0].status = 1
      cells[1][1].status = 1
      logic.step
    end

    it 'dies' do
      expect(cells[0][0].status).to be 0
      expect(cells[1][1].status).to be 0
    end
  end

  describe 'Any live cell with two or three live neighbours' do
    # 1 = alive
    #
    # [0][1][0]
    # [0][1][0]
    # [0][1][0]
    #
    # after step
    #
    # [0][0][0]
    # [1][1][1]
    # [0][0][0]

    before do
      cells[0][1].status = 1
      cells[1][1].status = 1
      cells[2][1].status = 1

      logic.step
    end

    it 'lives on to the next generation' do
      [[0, 1], [2, 1]].each do |i|
        expect(cells[i[0]][i[1]].status).to eq 0
      end

      [[1, 0], [1, 1], [1, 2]].each do |i|
        expect(cells[i[0]][i[1]].status).to eq 1
      end
    end
  end

  describe 'Any live cell with more than three live neighbours ' do
    # [1][1][1]
    # [0][1][1]
    # [0][1][0]
    #
    # after step
    #
    # [1][0][1]
    # [0][0][0]
    # [0][1][1]

    let(:cell_statuses) do
      [
        [0, 1],
        [1, 1],
        [1, 2]
      ]
    end

    before do
      cells[0][0].status = 1
      cells[0][1].status = 1
      cells[0][2].status = 1
      cells[1][1].status = 1
      cells[1][2].status = 1
      cells[2][1].status = 1
      logic.step
    end

    it 'dies, as if by overcrowding' do
      cell_statuses.each do |i|
        expect(cells[i[0]][i[1]].status).to eq 0
      end
    end
  end

  describe 'Any dead cell with exactly three live neighbours' do
    # [1][1][1]
    # [0][0][0]
    # [0][0][0]
    #
    # after step
    #
    # [1][1][1]
    # [0][1][0]
    # [0][0][0]

    let(:cell_statuses) do
      [
        [0, 1],
        [1, 1],
        [1, 2]
      ]
    end

    before do
      cells[0][0].status = 1
      cells[0][1].status = 1
      cells[0][2].status = 1
      logic.step
    end

    it 'becomes a live cell, as if by reproduction.' do
      expect(cells[1][1].status).to eq 1
    end
  end
end
