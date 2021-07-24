# frozen_string_literal: true

require './lib/receipt'
require './lib/line_item'

RSpec.describe Receipt do
  describe '#formatted_output' do
    context 'when non-imported items are purchased' do
      let(:line_item1) { LineItem.new(1, 'book', 12.49) }
      let(:line_item2) { LineItem.new(1, 'music cd', 14.99) }
      let(:line_item3) { LineItem.new(1, 'chocolate bar', 0.85) }
      let(:expected_output) do
        "1, book, 12.49\n1, music cd, 16.49\n1, chocolate bar, 0.85\n\nSales Taxes: 1.50\nTotal: 29.83\n\n"
      end

      let(:receipt) { Receipt.new([line_item1, line_item2, line_item3]) }

      it 'returns the receipt with sales tax calculated' do
        expect(receipt.formatted_output).to eq expected_output
      end
    end

    context 'when imported items are purchased' do
      let(:line_item1) { LineItem.new(1, 'imported box of chocolates', 10.00) }
      let(:line_item2) { LineItem.new(1, 'imported bottle of perfume', 47.50) }

      let(:expected_output) do
        "1, imported box of chocolates, 10.50\n1, imported bottle of perfume, 54.65\n\nSales Taxes: 7.65\nTotal: 65.15\n\n"
      end

      let(:receipt) { Receipt.new([line_item1, line_item2]) }

      it 'adds import duty' do
        expect(receipt.formatted_output).to eq expected_output
      end
    end
  end

  context 'when imported and other items are purchased' do
    let(:line_item1) { LineItem.new(1, 'imported bottle of perfume', 27.99) }
    let(:line_item2) { LineItem.new(1, 'bottle of perfume', 18.99) }
    let(:line_item3) { LineItem.new(1, 'packet of headache pills', 9.75) }
    let(:line_item4) { LineItem.new(1, 'imported box of chocolates', 11.25) }
    let(:expected_output) do
      "1, imported bottle of perfume, 32.19\n1, bottle of perfume, 20.89\n1, packet of headache pills, 9.75\n1, imported box of chocolates, 11.85\n\nSales Taxes: 6.70\nTotal: 74.68\n\n"
    end

    let(:receipt) { Receipt.new([line_item1, line_item2, line_item3, line_item4]) }

    it 'returns the receipt with appropriate sales tax and import duty' do
      expect(receipt.formatted_output).to eq expected_output
    end
  end
end
