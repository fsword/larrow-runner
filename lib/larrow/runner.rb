require "larrow/runner/version"
require 'logger'
require 'active_support/deprecation'
require 'active_support/core_ext/hash'

module Larrow
  module Runner
    Logger = if ENV['RUN_AS']=='test'
               Logger.new 'test.log'
             else
               Logger.new $stdout
             end
  end
end

require 'larrow/runner/config'
require 'larrow/runner/errors'
require 'larrow/runner/vcs'
require 'larrow/runner/manifest'
require 'larrow/runner/service'

require 'larrow/runner/manager'
require 'larrow/runner/command'


