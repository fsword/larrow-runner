module Larrow
  module Runner
    module Scm
      autoload :Base, 'larrow/runner/scm/base'
      autoload :Github, 'larrow/runner/scm/github'
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
