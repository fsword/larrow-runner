require "larrow/runner/version"
require 'active_support/deprecation'
require 'active_support/core_ext/hash'

module Larrow
  module Runner
    autoload :Command, 'larrow/runner/command'
    autoload :Config,  'larrow/runner/config'
    autoload :World,   'larrow/runner/world'
    autoload :Scm,     'larrow/runner/scm'
    autoload :Node,    'larrow/runner/node'
  end
end
