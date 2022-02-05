# frozen_string_literal: true

# .rubocop.yml
module WorkWithCSV
  module_function

  def create_file(filename)
    CSV.open(filename, 'w')
    write_headers_to_file(filename)
    puts "File #{filename} created"
  end

  def write_headers_to_file(filename)
    headers = %w[Name Price Image]
    CSV.open(filename, 'a+') do |row|
      row << headers
    end
  end

  def write_to_file(data_to_write, product_name)
    CSV.open(WorkWithYaml.read_parameters[0], 'a+') do |row|
      row << data_to_write
    end
    puts "-----product #{product_name.strip} is written into #{WorkWithYaml.read_parameters[0]}-----"
  end
end
