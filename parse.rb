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
    # puts pages.size.to_s
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
      threads_set_count << Thread.new { download_pages(go_to_next_page(url, p_counter)) }
    end
    write_pages_of_products(threads_set_count.map(&:value))
  end

  def go_to_next_page(url, page_num)
    puts "Start downloading page #{page_num} of products"
    if page_num > 1
      WorkWithUrl.form_page_url(url, page_num)
    else
      url
    end
  end

  def write_pages_of_products(pages)
    threads = []
    global_array_of_products = []
    pages.each do |page|
      puts "Writing page #{page} into file"
      threads << Thread.new { form_pages_order(page, global_array_of_products) }
    end
    threads.map(&:value)
    write_array
  end

  def form_pages_order(pages, global_array_of_products)
    pages.each do |html|
      parse_product(html, global_array_of_products)
    end
  end

  def write_array
    WorkWithCSV.write_to_file($global_array_of_products)
  end
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

  # def set_count_products_to_parse(count_products, p_counter, product_per_page, url)
  #   puts "Page #{p_counter} downloading... #{count_products}"
  #   url = WorkWithUrl.form_page_url(url, p_counter) if p_counter > 1
  #   if count_products < product_per_page
  #     download_pages(count_products, url)
  #   else
  #     download_pages(product_per_page, url)
  #   end
  # end


