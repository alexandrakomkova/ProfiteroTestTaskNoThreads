# frozen_string_literal: true

require 'csv'
require 'rubygems'
require 'curb'
require 'nokogiri'

require_relative 'parse'
require_relative 'work_with_yaml'


time = Time.now.to_i
if ARGV.length != 2
  puts 'Enter 2 arguments: url and filename'
else
  Parse.parse(ARGV[0], ARGV[1])
  puts "Work is done, check the file #{ARGV[1]}"
end
time1 = Time.now.to_i
puts "#{time1 - time} sec"
