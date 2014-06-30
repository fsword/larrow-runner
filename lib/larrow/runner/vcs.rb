module Larrow
  module Runner
    module Vcs
      autoload :Base, 'larrow/runner/vcs/base'
      autoload :Github, 'larrow/runner/vcs/github'
      def self.formatted url
        if url =~ /github/
          Github.new(url).formatted_url
        end
      end
    end
  end
end
