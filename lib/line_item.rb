# frozen_string_literal: true

# Calculate sales tax on a purchase
class LineItem
  TAX_RATE = 10
  IMPORT_DUTY = 5
  NON_TAXABLE = %w[book chocolate chocolates pills].freeze
  IMPORTED = %w[imported].freeze

  attr_reader :name, :quantity

  def initialize(quantity, name, shelf_price)
    @quantity = quantity
    @name = name
    @shelf_price = shelf_price
    @cost = shelf_price * quantity
  end

  def total_sales_tax
    round_up_to_nearest005(calculate_sales_tax + calculate_import_duty)
  end

  def total_cost
    format('%.2f', @cost + total_sales_tax)
  end

  private

  def calculate_sales_tax
    return 0 if NON_TAXABLE.any? { |item| @name.include? item }

    @cost * TAX_RATE / 100
  end

  def calculate_import_duty
    return 0 unless IMPORTED.any? { |item| @name.include? item }

    @cost * IMPORT_DUTY / 100
  end

  # round up to nearest 0.05
  def round_up_to_nearest005(tax)
    (tax * 20).ceil / 20.0
  end
end
