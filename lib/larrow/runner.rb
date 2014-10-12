require 'active_support/deprecation'
require 'active_support/core_ext/hash'

require "larrow/runner/version"
require 'larrow/runner/logger'
require 'larrow/runner/service'
require 'larrow/runner/session'

require 'larrow/runner/errors'

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
    Cloud = Session.load_cloud
  end
end

require 'larrow/runner/vcs'
require 'larrow/runner/manifest'
require 'larrow/runner/helper'

require 'larrow/runner/manager'
require 'larrow/runner/cli'
require 'larrow/runner/model/app'
require 'larrow/runner/model/node'

