module Larrow
  module Runner
    module Scm
      def self.parse url
        if url =~ /github/
          Github.new url
        end
      end
      autoload :Base, 'larrow/runner/scm/base'
      autoload :Github, 'larrow/runner/scm/github'
    end
  end
end
