# frozen_string_literal: true

require_relative 'product'
# .rubocop.yml
module FormatData
  module_function

  def form_product_name(name, weight)
    "#{name.strip}\n#{weight}"
  end

  def prepare_data_to_write(name, img, weight, price)
    [form_product_name(name, form_product_weight(weight)), form_product_price(price),
     img]
  end

  def form_product_price(price)
    price.gsub(/\s+/, '').chop
  end

  def get_weight_measurement(weight)
    weight.delete('0-9')
  end

  def get_weight_number(weight)
    weight.delete('^0-9')
  end

  def form_product_weight(weight)
    case get_weight_measurement(weight.gsub(/\s+/, ''))
    when 'Gr', 'Gr.'
      "#{get_weight_number(weight)} gr"
    when 'Kg', 'Kg.'
      "#{get_weight_number(weight)} kg"
    else
      weight
    end
  end
end
