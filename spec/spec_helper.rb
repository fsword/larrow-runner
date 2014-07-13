$LOAD_PATH << File.expand_path('../../lib', __FILE__)

ENV['RUN_AS'] ||= 'test'

require 'larrow/runner'
require 'pry'
require 'pry-nav'
require 'simplecov'

SimpleCov.start
