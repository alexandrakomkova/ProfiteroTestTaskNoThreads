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

  def write_to_file(data_to_write)
    CSV.open(ARGV[1], 'a+') do |row|
      row << data_to_write
    end
  end
end
