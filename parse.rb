# frozen_string_literal: true

require 'csv'
require_relative 'work_with_csv'
require_relative 'work_with_parsed_data'
require_relative 'work_with_url'
require_relative 'product'
# .rubocop.yml
module Parse
  module_function

  def parse_product(html)
    product = Product.new(html)
    product.weight_variation.each_with_index do |weight, index|
      WorkWithParsedData.work_with_parsed_data(product.name,
                                               product.img,
                                               weight.text.to_s,
                                               product.price_per_weight[index].text.to_s)
    end
  end

  def download_pages(url)
    product_page = WorkWithUrl.get_html(url).xpath(WorkWithYaml.read_xpath_parse_parameters[0])
    threads = []
    product_page.each do |product_url|
      threads << Thread.new { download_product_page(product_url.to_s.gsub(/\s+/, '')) }
    end
    pages = threads.map(&:value)
  end

  def download_product_page(product_url)
    WorkWithUrl.get_html(product_url)
  end

  def parse(url, filename)
    WorkWithCSV.create_file(filename)
    product_per_page = WorkWithYaml.read_product_per_page_parameter
    count_products = WorkWithUrl.get_html(url).xpath(WorkWithYaml.read_xpath_parse_parameters[1]).text.to_i
    puts "Total count of goods: #{count_products}"
    count_pages = (count_products / product_per_page.to_f).ceil
    threads_set_count = []
    (1..count_pages).each do |p_counter|
      threads_set_count << Thread.new { download_pages(form_next_page_url(url, p_counter)) }
    end
    write_all_products(threads_set_count.map(&:value), filename)
  end

  def form_next_page_url(url, page_num)
    puts "Start downloading page #{page_num} of products"
    if page_num > 1
      WorkWithUrl.form_page_url(url, page_num)
    else
      url
    end
  end

  def write_all_products(pages, filename)
    puts "Start writing all products into the #{filename}"
    pages = pages.flatten
    pages.each do |html|
      parse_product(html)
    end
  end

  def form_pages_order(pages)
    pages.each do |html|
      parse_product(html)
    end
  end
end


