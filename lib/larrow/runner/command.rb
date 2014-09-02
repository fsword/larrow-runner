require 'thor'
require 'larrow/runner/command/build_command'
require 'larrow/runner/command/config_command'

module Larrow
  module Runner::Command
    class Main < ::Thor
      desc 'version','show version of larrow-runner'
      def version
        puts VERSION
      end

      desc 'go <target_url>','execute your app'
      long_desc <<-EOF
larrow will build a whole world for your application
EOF
      option :debug
      option :nocolor
      def go url
        Option.update options
        RunLogger.nocolor if Option.key? :nocolor
        Manager.new(url).go
      end
     
      desc 'build SUBCOMMAND', 'build your server or images'
      subcommand 'build', BuildCommand
      
      desc 'config SUBCOMMAND', 'generate/use config'
      subcommand 'config', ConfigCommand
    end

  end
end
