# frozen_string_literal: true

# Returns the receipt
class Receipt
  def initialize(line_items = [])
    @line_items = line_items
  end

  def data
    receipt_data = ''
    total_sales_tax = 0
    total_cost = 0
    @line_items.each do |line_item|
      total_sales_tax += line_item.total_sales_tax
      total_cost += line_item.total_cost.to_f
      receipt_data += "#{line_item.quantity}, #{line_item.name}, #{line_item.total_cost}\n"
    end

    receipt_data += "\nSales Taxes: #{format('%.2f', total_sales_tax)}"
    receipt_data += "\nTotal: #{format('%.2f', total_cost)}\n\n"

    receipt_data
  end
end
