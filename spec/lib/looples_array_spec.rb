describe LooplessArray do
  let( :list ) { [1,2] }
  let( :la ) { LooplessArray.new(list) }

  describe 'new' do
    it 'takes an optional array' do
      _la = LooplessArray.new([1])
      expect( _la[0] ).to eql 1
    end

    it 'intializes an empty list' do
      _la = LooplessArray.new
      expect( _la.size ).to be 0
    end
  end

  describe 'recurse_each' do
    it 'can traverse all elements in list' do
      _list = []
      la.recurse_each do |e|
        _list << e
      end

      expect( _list ).to eql list
    end
  end

  describe 'recurse_each_with_index' do
    it 'shows the right index' do
      _list = []
      la.recurse_each_with_index do |e, i|
        _list << i
      end
      expect( _list ).to eql (0...la.size).to_a
    end
  end

  describe 'rmap' do
    it 'returns an empty LooplessArray if list is empty' do
      _la = LooplessArray.new
      expect( _la.rmap.size ).to eql 0
    end

    it 'returns a new instance of LooplessArray' do
      _la = LooplessArray.new
      expect( _la.rmap ).to be_a LooplessArray
    end

    it 'it returns a transformed LooplessArray' do
      _la = la.rmap{ |e| e + 1 }
      _la.recurse_each_with_index do |e, i|
        expect(e).to eq(list[i] + 1)
      end
    end
  end
end
