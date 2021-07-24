# frozen_string_literal: true

require 'rspec/core/rake_task'
require './lib/receipt'
require './lib/line_item'
require './lib/shopping_basket_parser'

RSpec::Core::RakeTask.new(:spec)

task default: %w[run]

desc 'Run all specs'
task test: :spec

desc 'Generate receipts'
task :run do
  Rake::Task['receipt1'].invoke
  Rake::Task['receipt2'].invoke
  Rake::Task['receipt3'].invoke
end

task :receipt1 do
  shopping_basket1 = 'Quantity, Product, Price
    1, book, 12.49
    1, music cd, 14.99
    1, chocolate bar, 0.85'

  line_items = ShoppingBasketParser.new(shopping_basket1).parse
  puts 'Receipt 1'
  puts Receipt.new(line_items).formatted_output
end

task :receipt2 do
  shopping_basket2 = 'Quantity, Product, Price
    1, imported box of chocolates, 10.00
    1, imported bottle of perfume, 47.50'

  line_items = ShoppingBasketParser.new(shopping_basket2).parse
  puts 'Receipt 2'
  puts Receipt.new(line_items).formatted_output
end

task :receipt3 do
  # not handling the case where the input is 'box of imported chocolates',
  # whereas the output is 'imported box of chocolates'
  shopping_basket3 = 'Quantity, Product, Price
    1, imported bottle of perfume, 27.99
    1, bottle of perfume, 18.99
    1, packet of headache pills, 9.75
    1, box of imported chocolates, 11.25'

  line_items = ShoppingBasketParser.new(shopping_basket3).parse
  puts 'Receipt 3'
  puts Receipt.new(line_items).formatted_output
end
