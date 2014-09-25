require 'thor'
require 'larrow/runner/cli/build'
require 'larrow/runner/cli/config'

module Larrow
  module Runner
    class Command < ::Thor
      desc 'version','show version of larrow-runner'
      def version
        puts VERSION
      end

      desc 'go [URL]','execute your app'
      long_desc <<-EOF
larrow will build a whole world for your application
      EOF
      option :debug
      option :nocolor
      def go url
        RunOption.update options
        RunLogger.nocolor if RunOption.key? :nocolor
        Manager.new(url).go
      end
     
      desc 'dump [URL]','convert and dump configuration of the project'
      long_desc <<-EOF
Read other CI file(eg:.travis.yml), conert to larrow style and dump to STDOUT. 
You can save it as .larrow.yml on the project root folder.
      EOF
      def dump url
        vcs = Vcs.detect url
        configuration = vcs.configuration false
        puts configuration.dump
      end

      desc 'build [SUBCOMMAND]', 'build your server or images'
      subcommand 'build', Cli::Build
      
      desc 'config [SUBCOMMAND]', 'generate/use config'
      subcommand 'config', Cli::Config
    end

  end
end
