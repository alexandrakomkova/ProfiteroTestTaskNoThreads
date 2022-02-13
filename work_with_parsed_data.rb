# frozen_string_literal: true

require_relative 'work_with_csv'
require_relative 'format_data'
# .rubocop.yml
module WorkWithParsedData
  module_function

  def work_with_parsed_data(name, img, weight, price)
    WorkWithCSV.write_to_file(FormatData.prepare_data_to_write(name, img, weight, price))
  end
end
