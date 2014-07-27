require 'thor'
module Larrow
  module Runner
    class Build < ::Thor
      desc 'server <target_url>','setup the server environment'
      def server url
        puts "build server by #{url}"
      end
     
      desc 'image <target_url>','setup environment and cache it as a image'
      def image url
        puts "build image by #{url}"
      end
    end

    class Command < ::Thor
      desc 'config','show all configuration'
      def config
        Config.generate
      end

      desc 'version','show version of larrow-runner'
      def version
        puts VERSION
      end

      desc 'go <target_url>','execute your app'
      long_desc <<-EOF
larrow will build a whole world for your application
EOF
      option :debug
      def go url
        Option.update options
        Manager.new(url).go
      end
     
      desc 'build SUBCOMMAND', 'build your server or images'
      subcommand 'build', Build
    end

  end
end
