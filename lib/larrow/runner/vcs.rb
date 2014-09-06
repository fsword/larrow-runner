require 'larrow/runner/vcs/base'
module Larrow
  module Runner
    # Access source code from Version Control System
    # eg: Subversion, Github, LocalStore
    module Vcs
      autoload :Github,   'larrow/runner/vcs/github'
      def self.detect url
        if url =~ /github/
          Github.new(url)
        end
      end

    end
  end
end
