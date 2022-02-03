# frozen_string_literal: true

require_relative 'product'
# .rubocop.yml
module FormatData
  module_function

  def form_product_name(name, weight)
    "#{name.strip} - #{weight}"
  end

  def prepare_data_to_write(name, img, weight, price)
    [form_product_name(name, weight), form_product_price(price),
     img]
  end

  def form_product_price(price)
    price.gsub(/\s+/, '').chop
  end

end
