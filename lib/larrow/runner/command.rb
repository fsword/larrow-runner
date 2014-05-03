require 'thor'
module Larrow
  module Core
    class Command < ::Thor
      desc 'config','show all configuration'
      def config
        filepath = "#{ENV['HOME']}/.larrow"
        Config.generate_config filepath unless File.exist? filepath
        puts File.read(filepath)
      end

      desc 'go','execute your app'
      def go url
        World.go url
      end
    end
  end
end
