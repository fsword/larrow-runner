require 'faraday'

module Larrow
  module Runner
    module Vcs
      class Github < Base
        URL_TEMPLATE='https://raw.githubusercontent.com/%s/%s/%s%s'
        attr_accessor :organize, :name, :branch
        # url sample:
        # git@github.com:fsword/larrow-qingcloud.git
        # https://github.com/fsword/larrow-qingcloud.git
        def initialize url
          self.branch = 'master'
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

        def get filename
          url = URL_TEMPLATE % [organize, name, branch, filename]
          Faraday.get(url).body
        end

        def source_sync_script
          ["git clone ",
           "--depth 1",
           "http://github.com/%s/%s.git",
           "-b %s $HOME/source"
          ].join(' ') % [organize, name, branch]
        end
      end
    end
  end
end
