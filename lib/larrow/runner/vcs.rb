module Larrow
  module Runner
    module Vcs
      autoload :Base, 'larrow/runner/vcs/base'
      autoload :Github, 'larrow/runner/vcs/github'
      def self.parse url
        if url =~ /github/
          Github.new url
        end
      end

      def larrow_spec
      end

      def gen
      end
    end
  end
end
