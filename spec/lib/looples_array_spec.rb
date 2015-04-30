describe LooplessArray do
  let(:list) { [1, 2] }
  let(:la) { LooplessArray.new(list) }

  describe 'new' do
    it 'takes an optional array' do
      expect(LooplessArray.new([1])[0]).to eql 1
    end

    it 'intializes an empty list' do
      expect(LooplessArray.new.size).to be 0
    end
  end

  describe 'recurse_each' do
    it 'can traverse all elements in list' do
      list2 = []
      la.recurse_each do |e|
        list2 << e
      end

      expect(list2).to eql list
    end
  end

  describe 'recurse_each_with_index' do
    it 'shows the right index' do
      list2 = []
      la.recurse_each_with_index do |_, i|
        list2 << i
      end
      expect(list2).to eql(0...la.size).to_a
    end
  end

  describe 'rmap' do
    it 'returns an empty LooplessArray if list is empty' do
      expect(LooplessArray.new.rmap.size).to eql 0
    end

    it 'returns a new instance of LooplessArray' do
      expect(LooplessArray.new.rmap).to be_a LooplessArray
    end

    it 'it returns a transformed LooplessArray' do
      la2 = la.rmap { |e| e + 1 }
      la2.recurse_each_with_index do |e, i|
        expect(e).to eq(list[i] + 1)
      end
    end
  end
end
