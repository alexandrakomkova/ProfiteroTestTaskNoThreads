# frozen_string_literal: true

require 'csv'
require_relative 'work_with_csv'
require_relative 'work_with_parsed_data'
require_relative 'work_with_url'
require_relative 'product'
# .rubocop.yml
module Parse
  module_function

  def parse_product(product_url)
    html = WorkWithUrl.get_html(product_url)
    product = Product.new(html)
    product.weight_variation.each_with_index do |weight, index|
      WorkWithParsedData.work_with_parsed_data(product.name,
                                               product.img,
                                               weight.text.to_s,
                                               product.price_per_weight[index].text.to_s)
    end
  end

  def parse_one_page(count_products, url)
    product_page = WorkWithUrl.get_html(url).xpath(WorkWithYaml.read_xpath_parse_parameters[0])
    threads = []
    (0...count_products).each do |product_counter|
      threads << Thread.new { parse_product(product_page[product_counter].to_s.gsub(/\s+/, '')) }
    end
    threads.each(&:join)
  end

  def parse(url, filename)
    WorkWithCSV.create_file(filename)
    product_per_page = WorkWithYaml.read_parameters[2]
    # count_products = WorkWithUrl.get_html(url).xpath(WorkWithYaml.read_xpath_parse_parameters[1]).text.to_i
    # if count_products == 0 then get count from product-count
    count_products = check_products_count(url)
    puts count_products
    count_pages = (count_products / product_per_page.to_f).ceil
    (1..count_pages).each do |p_counter|
      set_count_products_to_parse(count_products, p_counter, product_per_page, url)
      count_products -= product_per_page
    end
  end

  def set_count_products_to_parse(count_products, p_counter, product_per_page, url)
    url = WorkWithUrl.form_page_url(url, p_counter) if p_counter > 1
    if count_products < product_per_page
      parse_one_page(count_products, url)
    else
      parse_one_page(product_per_page, url)
    end
  end

  def check_products_count(url)
    if WorkWithUrl.get_html(url).xpath(WorkWithYaml.read_xpath_parse_parameters[1]).text.to_i.zero?
      puts WorkWithUrl.get_html(url).xpath(WorkWithYaml.read_xpath_parse_parameters_less_25[0]).text
    else
      WorkWithUrl.get_html(url).xpath(WorkWithYaml.read_xpath_parse_parameters[1]).text.to_i
    end
  end
end
