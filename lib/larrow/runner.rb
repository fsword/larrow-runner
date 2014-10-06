require 'active_support/deprecation'
require 'active_support/core_ext/hash'

require "larrow/runner/version"
require 'larrow/runner/logger'

module Larrow
  module Runner
    # default runtime logger
    RunLogger = if ENV['RUN_AS']
                  Logger.new "#{ENV['RUN_AS']}.log"
                else
                  Logger.new $stdout
                end
    # global options
    RunOption = {}.with_indifferent_access
    # cloud wrapper
    Cloud = Service::Cloud.new Session.load
  end
end

require 'larrow/runner/errors'
require 'larrow/runner/vcs'
require 'larrow/runner/manifest'
require 'larrow/runner/service'
require 'larrow/runner/helper'

require 'larrow/runner/session'
require 'larrow/runner/manager'
require 'larrow/runner/cli'
require 'larrow/runner/model/app'
require 'larrow/runner/model/node'

