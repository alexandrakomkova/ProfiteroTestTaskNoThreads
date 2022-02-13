# frozen_string_literal: true

require 'yaml'
# .rubocop.yml
module WorkWithYaml
  module_function

  # @return [Array]
  def read_product_per_page_parameter
    yaml_filename = 'parameters.yaml'
    parameters = YAML.safe_load(File.open(yaml_filename))
    parameters['product_per_page'].to_i
  end

  def read_xpath_product_parameters
    yaml_filename = 'parameters.yaml'
    parameters = YAML.safe_load(File.open(yaml_filename))
    [parameters['xpath_name'],
     parameters['xpath_img'],
     parameters['xpath_weight_variation'],
     parameters['xpath_price_per_weight']]
  end

  def read_xpath_parse_parameters
    yaml_filename = 'parameters.yaml'
    parameters = YAML.safe_load(File.open(yaml_filename))
    [parameters['xpath_product_page'], parameters['xpath_total_count']]
  end

end
