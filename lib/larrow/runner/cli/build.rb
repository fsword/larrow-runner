module Larrow::Runner
  module Cli
    class Build < ::Thor
      
      desc 'server <target_url>','build the server'
      long_desc <<-EOF.gsub("\n", "\x5")
Setup a server for application:
* assign resource
* init environment
* prepare server
* start server 
      EOF
      option :debug
      option :nocolor
      def server url
        RunOption.update options
        RunOption[:keep] = true
        RunLogger.nocolor if RunOption.key? :nocolor
        Manager.new(url).build_server
      end

      desc 'image <target_url/larrow_file_path>', 'build a base image'
      long_desc <<-EOF.gsub("\n", "\x5")
Reduce the time is very important for CI or other develop activity.
There is a best practise to build a image as base system for the project.  
Larrow will help you to make it simple and reuse the configuration items.

Your can use a single Larrowfile as the argument.
      EOF
      option :debug
      option :nocolor
      def image url
        RunOption.update options
        RunLogger.nocolor if RunOption.key? :nocolor
        Manager.new(url).build_image
      end

    end
  end
end

