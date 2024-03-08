require 'rspec'
require 'skip_list'

RSpec.describe SkipNodeList do

  let(:skip_list) { described_class.new(5, 0.5, 201) }

  let(:expected_before_remove) do
    <<~GRAPH
[H]------------------------------------>[9]
[H]------------------------------------>[9]
[H]--------------------->[6]----------->[9]
[H]----------->[3]------>[6]------>[8]->[9]
[H]->[1]->[2]->[3]->[5]->[6]->[7]->[8]->[9]
GRAPH
  end


  describe 'insert_points' do
    context 'when the list has only a head' do
      it 'returns a thing' do

        skip_list.insert(3)
        skip_list.insert(1)
        skip_list.insert(7)
        skip_list.insert(2)
        skip_list.insert(9)
        skip_list.insert(5)
        skip_list.insert(6)
        skip_list.insert(8)

        expect(skip_list.to_s).to eq(<<~GRAPH.strip)
          [H]------------------------------------>[9]
          [H]------------------------------------>[9]
          [H]--------------------->[6]----------->[9]
          [H]----------->[3]------>[6]------>[8]->[9]
          [H]->[1]->[2]->[3]->[5]->[6]->[7]->[8]->[9]
        GRAPH
        skip_list.remove(8)
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
