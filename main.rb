# frozen_string_literal: true

require 'csv'
require 'rubygems'
require 'curb'
require 'nokogiri'

require_relative 'parse'
require_relative 'work_with_yaml'

Parse.parse(WorkWithYaml.read_parameters[1], WorkWithYaml.read_parameters[0])
# https://www.petsonic.com/condroprotectores-articulaciones/
# https://www.petsonic.com/farmacia-para-gatos/
# product-count hidden-xs  Mostrando 1 - 11 de 11 artículos