require 'rspec'
require 'skip_list'

RSpec.describe SkipNodeList do

  let(:skip_list) { described_class.new(5, 0.5, 201) }
  let(:node_1) { SkipNode.new(3, 1) }
  let(:node_5) { SkipNode.new(4, 5) }

  describe 'insert_points' do
    context 'when the list has only a head' do
      it 'returns a list of just the head' do
        expect(skip_list.insert_points(3)).to eq([skip_list.head] * 5)
      end
    end

    context 'when the list has one smaller item' do

      # [H]
      # [H]
      # [H]->[1]
      # [H]->[1]
      # [H]->[1]

      before do
        3.times do |i|
          skip_list.head.next[i] = node_1
        end
      end

      it 'returns a list with both the head and the smaller item' do
        expect(skip_list.insert_points(3)).to eq([
                                                   node_1,
                                                   node_1,
                                                   node_1,
                                                   skip_list.head,
                                                   skip_list.head
                                                 ])
      end

      context 'when the list also has one larger item' do

        # [H]
        # [H]------>[5]
        # [H]->[1]->[5]
        # [H]->[1]->[5]
        # [H]->[1]->[5]

        before do
          skip_list.head.next[3] = node_5
          3.times do |i|
            node_1.next[i] = node_5
          end
        end

        it 'returns a list with both the head and the smaller item' do
          expect(skip_list.insert_points(3)).to eq([
                                                     node_1,
                                                     node_1,
                                                     node_1,
                                                     skip_list.head,
                                                     skip_list.head
                                                   ])
        end
      end
    end
  end


  describe 'after inserting' do
    before do
      skip_list.insert(3)
      skip_list.insert(1)
      skip_list.insert(7)
      skip_list.insert(2)
      skip_list.insert(9)
      skip_list.insert(5)
      skip_list.insert(6)
      skip_list.insert(8)
    end
    it 'inserts the nodes in the right places' do

      expect(skip_list.to_s).to eq(<<~GRAPH.strip)
        [H]------------------------------------>[9]
        [H]------------------------------------>[9]
        [H]--------------------->[6]----------->[9]
        [H]----------->[3]------>[6]------>[8]->[9]
        [H]->[1]->[2]->[3]->[5]->[6]->[7]->[8]->[9]
      GRAPH
    end

    context 'after removal' do
      before do
        skip_list.remove(8)
      end

      it 'removes the node and reassigns pointers' do
        expect(skip_list.to_s).to eq(<<~GRAPH.strip)
          [H]------------------------------->[9]
          [H]------------------------------->[9]
          [H]--------------------->[6]------>[9]
          [H]----------->[3]------>[6]------>[9]
          [H]->[1]->[2]->[3]->[5]->[6]->[7]->[9]
        GRAPH

      end
    end
  end
end
