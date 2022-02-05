# frozen_string_literal: true

require 'csv'
require_relative 'work_with_csv'
require_relative 'work_with_parsed_data'
require_relative 'work_with_url'
require_relative 'product'
# .rubocop.yml
module Parse
  module_function

  # def parse_product(product_url)
  #   html = WorkWithUrl.get_html(product_url)
  #   product = Product.new(html)
  #   product.weight_variation.each_with_index do |weight, index|
  #     WorkWithParsedData.work_with_parsed_data(product.name,
  #                                              product.img,
  #                                              weight.text.to_s,
  #                                              product.price_per_weight[index].text.to_s)
  #   end
  # end

  # no threads
  # def parse_one_page(count_products, url)
  #   product_page = WorkWithUrl.get_html(url).xpath(WorkWithYaml.read_xpath_parse_parameters[0])
  #   (0...count_products).each do |product_counter|
  #     parse_product(product_page[product_counter].to_s.gsub(/\s+/, ''))
  #   end
  # end

  # with threads
  # def parse_one_page(count_products, url)
  #   product_page = WorkWithUrl.get_html(url).xpath(WorkWithYaml.read_xpath_parse_parameters[0])
  #   threads = []
  #   (0...count_products).each do |product_counter|
  #     threads << Thread.new { parse_product(product_page[product_counter].to_s.gsub(/\s+/, '')) }
  #   end
  #   threads.map(&:join)
  # end

  def parse_product(html)
    product = Product.new(html)
    product.weight_variation.each_with_index do |weight, index|
      WorkWithParsedData.work_with_parsed_data(product.name,
                                               product.img,
                                               weight.text.to_s,
                                               product.price_per_weight[index].text.to_s)
    end
  end

  def download_product_page(product_url)
    WorkWithUrl.get_html(product_url)
  end

  def parse_one_page(count_products, url)
    product_page = WorkWithUrl.get_html(url).xpath(WorkWithYaml.read_xpath_parse_parameters[0])
    threads = []
    pages = []
    (0...count_products).each do |product_counter|
      threads << Thread.new {
        # puts "thread num #{product_counter}"
        download_product_page(product_page[product_counter].to_s.gsub(/\s+/, ''))
      }
      # pages[product_counter].push(threads[product_counter])
      # puts "pages: "+ product_counter.to_s
      # write_pages_queque(product_counter,count_products)
    end
    pages = threads.map(&:value)
    form_pages_order(pages)
  end

  def form_pages_order(pages)
    pages.each do |html|
      parse_product(html)
    end
  end

  def parse(url, filename)
    WorkWithCSV.create_file(filename)
    product_per_page = WorkWithYaml.read_parameters[2]
    count_products = WorkWithUrl.get_html(url).xpath(WorkWithYaml.read_xpath_parse_parameters[1]).text.to_i
    puts "Total count of goods: #{count_products}"
    count_pages = (count_products / product_per_page.to_f).ceil
    (1..count_pages).each do |p_counter|
      set_count_products_to_parse(count_products, p_counter, product_per_page, url)
      count_products -= product_per_page
    end
    puts 'Work is done, check the file.'
  end

  def set_count_products_to_parse(count_products, p_counter, product_per_page, url)
    url = WorkWithUrl.form_page_url(url, p_counter) if p_counter > 1
    if count_products < product_per_page
      parse_one_page(count_products, url)
    else
      parse_one_page(product_per_page, url)
    end
  end
end
