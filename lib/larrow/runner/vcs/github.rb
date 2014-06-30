require 'octokit'
module Larrow
  module Runner
    module Vcs
      class Github < Base
        attr_accessor :organize, :name
        # url sample:
        # git@github.com:fsword/larrow-qingcloud.git
        # https://github.com/fsword/larrow-qingcloud.git
        def initialize url
          case url
          when /git@github\.com:(.+)\/(.+)\.git/
            self.organize = $1
            self.name     = $2
          when /http.:\/\/github.com\/(.+)\/(.+)\.git/
            self.organize = $1
            self.name     = $2
          end
        end

        def formatted_url
          'git@github.com:%s/%s.git' % [organize, name]
        end

      end
    end
  end
end
