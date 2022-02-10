# frozen_string_literal: true

require 'csv'
require 'rubygems'
require 'curb'
require 'nokogiri'

require_relative 'parse'
require_relative 'work_with_yaml'

# in file parameters.yaml you can change url and filename
# Parse.parse(WorkWithYaml.read_parameters[1], WorkWithYaml.read_parameters[0])
time = Time.now.to_i
if ARGV.length != 2
  puts 'Enter 2 arguments: url and filename'
else
  WorkWithCSV.create_file(ARGV[1])
  Parse.parse(ARGV[0], ARGV[1])
  puts "Work is done, check the file #{ARGV[1]}"
end
time1 = Time.now.to_i
puts "#{time1 - time} sec"
# filename: parsedProducts.csv
# url: https://www.petsonic.com/dermatitis-y-problemas-piel-para-perros/
