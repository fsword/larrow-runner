require "larrow/runner/version"

module Larrow
  module Runner
    autoload :Command, 'larrow/runner/command'
    autoload :Config,  'larrow/runner/config'
    autoload :World,   'larrow/runner/world'
    autoload :Scm,     'larrow/runner/scm'
  end
end
