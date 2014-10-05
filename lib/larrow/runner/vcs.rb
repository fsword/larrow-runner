require 'larrow/runner/vcs/base'
module Larrow
  module Runner
    # Access source code from Version Control System
    # eg: Subversion, Github, LocalStore
    module Vcs
      autoload :Github,    'larrow/runner/vcs/github'
      autoload :FileSystem,'larrow/runner/vcs/file_system'
      def self.detect url
        case url
        when /github/
          Github.new(url)
        else
          fail "cannot recognized: #{url}" unless File.directory? url
          FileSystem.new url
        end
      end
    end
  end
end
