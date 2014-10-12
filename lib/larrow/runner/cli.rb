require 'thor'

module Larrow
  module Runner
    module Cli
      autoload :Main,   'larrow/runner/cli/main'
      autoload :Build,  'larrow/runner/cli/build'
      autoload :Tools,  'larrow/runner/cli/tools'
    end
  end
end
