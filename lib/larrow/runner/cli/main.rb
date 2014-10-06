module Larrow::Runner
  module Cli
    class Main < ::Thor
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

      desc 'login', 'log into Qingcloud service'
      option :force
      def login
        RunOption.update options
        Session.login
      end

      desc 'build [SUBCOMMAND]', 'build your server or images'
      subcommand 'build', Build

      desc 'tools [SUBCOMMAND]', 'some tools'
      subcommand 'tools', Tools

      desc 'config [SUBCOMMAND]', 'generate/use config'
      subcommand 'config',Config
    end
  end
end
