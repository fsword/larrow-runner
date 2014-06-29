require 'thor'
module Larrow
  module Runner
    class Command < ::Thor
      desc 'config','show all configuration'
      def config
        Config.generate
      end

      desc 'go <target_url>','execute your app'
      long_desc <<-EOF
larrow will build a whole world for your application
EOF
      def go url
        Manager.new(url).go
      end
    end
  end
end
