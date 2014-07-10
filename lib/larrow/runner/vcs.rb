module Larrow
  module Runner
    # Access source code from Version Control System
    # eg: Subversion, Github, LocalStore
    module Vcs
      autoload :Base,     'larrow/runner/vcs/base'
      autoload :Github,   'larrow/runner/vcs/github'
      def self.parse url
        if url =~ /github/
          Github.new(url)
        end
      end

    end
  end
end
