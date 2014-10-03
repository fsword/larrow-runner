require 'faraday'

module Larrow::Runner::Vcs
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
      resp = Faraday.get(url)
      case resp.status
      when 200
        resp.body
      when 404
        nil
      else
        raise resp.body
      end
    end

    def update_source node, target_dir
      template = ["git clone ",
                  "--depth 1",
                  "http://github.com/%s/%s.git",
                  "-b %s %s"].join(' ')
      cmd = template % [organize, name, branch, target_dir]
      node.execute cmd
    end
  end
end
