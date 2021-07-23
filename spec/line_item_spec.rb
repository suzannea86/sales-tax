# frozen_string_literal: true

require './lib/line_item'

RSpec.describe LineItem do
  subject(:total_cost) { line_item.total_cost }
  subject(:total_sales_tax) { line_item.total_sales_tax }

  describe '#total_cost' do
    context 'when a non imported item is purchased' do
      context 'when a book is purchased' do
        let(:line_item) { LineItem.new(1, 'book', 12.49) }

        it 'cost not changed' do
          expect(total_cost.to_f).to eq 12.49
        end

        it 'sales tax is 0' do
          expect(total_sales_tax).to eq 0
        end
      end

      context 'when a music item is purchased' do
        let(:line_item) { LineItem.new(1, 'music cd', 14.99) }

        it 'adds sales tax to cost' do
          expect(total_cost.to_f).to eq 16.49
        end

        it 'sales tax is non zero' do
          expect(total_sales_tax).to eq 1.5
        end
      end

      context 'when a food item is purchased' do
        let(:line_item) { LineItem.new(1, 'chocolate bar', 0.85) }

        it 'cost remains same' do
          expect(total_cost.to_f).to eq 0.85
        end

        it 'sales tax is 0' do
          expect(total_sales_tax).to eq 0
        end
      end

      context 'when a medical item is purchased' do
        let(:line_item) { LineItem.new(1, 'packet of headache pills', 9.75) }

        it 'cost reamins same' do
          expect(total_cost.to_f).to eq 9.75
        end

        it 'sales tax is 0' do
          expect(total_sales_tax).to eq 0
        end
      end

      context 'when passed a non handled value for tax exempt data' do
        let(:line_item) { LineItem.new(1, 'box of biscuits', 14.99) }

        it 'treated as a taxed input' do
          expect(total_cost.to_f).to eq 16.49
        end

        it 'sales tax is non zero' do
          expect(total_sales_tax).to eq 1.5
        end
      end
    end

    context 'when an imported item is purchased' do
      context 'when the item is tax exempt' do
        let(:line_item) { LineItem.new(1, 'imported box of chocolates', 10.00) }

        it 'adds import duty to cost' do
          expect(total_cost.to_f).to eq 10.50
        end

        it 'sales tax is 5% import duty' do
          expect(total_sales_tax).to eq 0.5
        end
      end

      context 'when the item is non tax exempt' do
        let(:line_item) { LineItem.new(1, 'imported bottle of perfume', 47.50) }

        it 'adds import duty and sales tax to cost' do
          expect(total_cost.to_f).to eq 54.65
        end

        it 'sales tax is 10% plus 5% import duty' do
          expect(total_sales_tax).to eq 7.15
        end
      end
    end
  end
end
