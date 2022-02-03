# frozen_string_literal: true

require_relative 'work_with_yaml'
# .rubocop.yml
class Product
  attr_accessor :name, :price_per_weight, :img, :weight_variation

  def initialize(html)
    @name = get_info_about_product(html)[0]
    @img = get_info_about_product(html)[1]
    @weight_variation = get_info_about_product(html)[2]
    @price_per_weight = get_info_about_product(html)[3]
  end

  def get_info_about_product(html)
    product_name = html.xpath(WorkWithYaml.read_xpath_product_parameters[0]).text
    product_img = html.xpath(WorkWithYaml.read_xpath_product_parameters[1])
    product_weight_variation = html.xpath(WorkWithYaml.read_xpath_product_parameters[2])
    price_per_weight = html.xpath(WorkWithYaml.read_xpath_product_parameters[3])
    [product_name, product_img, product_weight_variation, price_per_weight]
  end
end
