require 'active_support/deprecation'
require 'active_support/core_ext/hash'
require 'pry'
require 'pry-nav'

require "larrow/runner/version"
require 'larrow/runner/logger'

module Larrow
  module Runner
    RunLogger = if ENV['RUN_AS']=='test'
                  Logger.new 'test.log'
                else
                  Logger.new $stdout
                end
    RunOption = {}.with_indifferent_access
  end
end

require 'larrow/runner/option'
require 'larrow/runner/errors'
require 'larrow/runner/vcs'
require 'larrow/runner/manifest'
require 'larrow/runner/service'
require 'larrow/runner/helper'

require 'larrow/runner/manager'
require 'larrow/runner/image_builder'
require 'larrow/runner/command'

