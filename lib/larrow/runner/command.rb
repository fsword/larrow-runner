require 'thor'
require 'larrow/runner/cli/build_command'
require 'larrow/runner/cli/config_command'

module Larrow
  module Runner
    class Command < ::Thor
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
      subcommand 'build', Cli::BuildCommand
      
      desc 'config SUBCOMMAND', 'generate/use config'
      subcommand 'config', Cli::ConfigCommand
    end

  end
end
