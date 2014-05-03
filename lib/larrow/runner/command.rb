require 'thor'
module Larrow
  module Runner
    class Command < ::Thor
      desc 'config','show all configuration'
      def config
        filepath = "#{ENV['HOME']}/.larrow"
        Config.generate_config filepath unless File.exist? filepath
        puts File.read(filepath)
      end

      desc 'go <target_url>','execute your app'
      long_desc <<-EOF
larrow will build a whole world for your application
EOF
      def go url
        World.new(url).go
      end
    end
  end
end
