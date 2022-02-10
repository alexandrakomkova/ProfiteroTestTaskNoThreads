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

  def download_pages(count_products, url)
    product_page = WorkWithUrl.get_html(url).xpath(WorkWithYaml.read_xpath_parse_parameters[0])
    threads = []
    (0...count_products).each do |product_counter|
      threads << Thread.new { download_product_page(product_page[product_counter].to_s.gsub(/\s+/, '')) }
    end
    pages = threads.map(&:value)
    #puts pages.size.to_s
    pages
    # form_pages_order(pages)
  end

  def download_product_page(product_url)
    # puts 'download_product_page'
    WorkWithUrl.get_html(product_url)
  end

  def parse(url, filename)
    product_per_page = WorkWithYaml.read_product_per_page
    count_products = WorkWithUrl.get_html(url).xpath(WorkWithYaml.read_xpath_parse_parameters[1]).text.to_i
    puts "Total count of goods: #{count_products}"
    count_pages = (count_products / product_per_page.to_f).ceil
    threads_set_count = []
    (1..count_pages).each do |p_counter|
      go_to_next_page(p_counter)
      download_pages.each { |product_html| parse_product(product_html) }
      threads_set_count << Thread.new { set_count_products_to_parse(count_products, p_counter, product_per_page, url) }
      sleep(1)
      count_products -= product_per_page
    end
    # pages_per_25 = threads_set_count.map(&:value)
    write_pages_of_products(threads_set_count.map(&:value))
  end
  def go_to_next_page(page_num)
    puts "Going to #{page_num} page of products"
    WorkWithUrl.get_html(WorkWithUrl.form_page_url(url, page_num)) if page_num > 1
  end
  #
  # def parse(url, filename)
  #   product_per_page = 25
  #   count_products = WorkWithUrl.get_html(url).xpath(WorkWithYaml.read_xpath_parse_parameters[1]).text.to_i
  #   puts "Total count of goods: #{count_products}"
  #   count_pages = (count_products / product_per_page.to_f).ceil
  #   threads_set_count = []
  #   (1..count_pages).each do |p_counter|
  #     puts "count_products #{count_products}"
  #     threads_set_count << Thread.new { set_count_products_to_parse(count_products, p_counter, product_per_page, url) }
  #     sleep(1)
  #     count_products -= product_per_page
  #   end
  #   # pages_per_25 = threads_set_count.map(&:value)
  #   write_pages_of_products(threads_set_count.map(&:value))
  # end

  def set_count_products_to_parse(count_products, p_counter, product_per_page, url)
    puts "Page #{p_counter} downloading... #{count_products}"
    url = WorkWithUrl.form_page_url(url, p_counter) if p_counter > 1
    if count_products < product_per_page
      download_pages(count_products, url)
    else
      download_pages(product_per_page, url)
    end
  end

  def write_pages_of_products(pages)
    pages.each do |page|
      puts "write_pages_of_products #{page.size}"
      form_pages_order(page)
    end
  end

  def form_pages_order(pages)
    pages.each do |html|
      parse_product(html)
    end
  end
end
