# frozen_string_literal: true

require './lib/line_item'

# parse input string
class ShoppingBasketParser
  def initialize(shopping_basket)
    @shopping_basket = shopping_basket
  end

  def parse
    shopping_array = @shopping_basket.split("\n").compact

    delete_header(shopping_array)

    get_line_items(shopping_array)
  end

  private

  def get_line_items(shopping_array)
    shopping_array.map do |item|
      quantity, name, shelf_price = item.strip.split(',').map(&:strip)

      raise ArgumentError, 'Quantity is not numeric' if quantity !~ /^\d*$/
      raise ArgumentError, 'Name is not a string' if name =~ /^[0-9]*$/
      raise ArgumentError, 'Price is not float' if shelf_price !~ /^\d+\.\d\d$/

      LineItem.new(quantity.to_i, name, shelf_price.to_f)
    end
  end

  def delete_header(shopping_array)
    raise ArgumentError, 'Header not supplied' unless shopping_array[0] == 'Quantity, Product, Price'

    shopping_array.delete_at(0)
  end
end
