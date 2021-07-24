# frozen_string_literal: true

require './lib/shopping_basket_parser'

RSpec.describe ShoppingBasketParser do
  let(:shopping_basket1) do
    'Quantity, Product, Price
    1, book, 12.49
    1, music cd, 14.99
    1, chocolate bar, 0.85'
  end

  let(:line_item1) { LineItem.new(quantity: 1, name: 'book', shelf_price: 12.49) }
  let(:line_item2) { LineItem.new(quantity: 1, name: 'music cd', shelf_price: 14.99) }
  let(:line_item3) { LineItem.new(quantity: 1, name: 'chocolate bar', shelf_price: 0.85) }

  subject(:line_items) { ShoppingBasketParser.new(shopping_basket1).parse }

  describe 'parse' do
    it 'returns expected number of Line Items' do
      expect(line_items.length).to eq 3
    end

    it 'returns objects of type LineItem' do
      expect(line_items[0]).to be_an_instance_of(LineItem)
      expect(line_items[1]).to be_an_instance_of(LineItem)
      expect(line_items[2]).to be_an_instance_of(LineItem)
    end

    it 'returns expected values' do
      expect(line_items[0]).to have_attributes(quantity: 1, name: 'book', shelf_price: 12.49)
      expect(line_items[1]).to have_attributes(quantity: 1, name: 'music cd', shelf_price: 14.99)
      expect(line_items[2]).to have_attributes(quantity: 1, name: 'chocolate bar', shelf_price: 0.85)
    end

    context 'exceptions' do
      let(:shopping_basket_with_bad_name) do
        'Quantity, Product, Price
        1, 23, 12.49'
      end

      let(:shopping_basket_with_bad_quantity) do
        'Quantity, Product, Price
        q, book, 12.49'
      end

      let(:shopping_basket_with_bad_price) do
        'Quantity, Product, Price
        1, book, 1'
      end

      let(:shopping_basket_with_no_header) do
        '1, book, 10.00'
      end

      subject(:parse_with_bad_name) { ShoppingBasketParser.new(shopping_basket_with_bad_name).parse }
      subject(:parse_with_bad_quantity) { ShoppingBasketParser.new(shopping_basket_with_bad_quantity).parse }
      subject(:parse_with_bad_price) { ShoppingBasketParser.new(shopping_basket_with_bad_price).parse }
      subject(:parse_with_no_header) { ShoppingBasketParser.new(shopping_basket_with_no_header).parse }

      it 'raises an exception if quantity is not string' do
        expect { parse_with_bad_quantity }.to raise_error(ArgumentError, 'Quantity is not numeric')
      end

      it 'raises an exception if name is not string' do
        expect { parse_with_bad_name }.to raise_error(ArgumentError, 'Name is not a string')
      end

      it 'raises an exception if price is not string' do
        expect { parse_with_bad_price }.to raise_error(ArgumentError, 'Price is not float')
      end

      it 'raises an exception if header not supplied' do
        expect { parse_with_no_header }.to raise_error(ArgumentError, 'Header not supplied')
      end
    end
  end
end
